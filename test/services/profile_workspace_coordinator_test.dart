import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meshcore_client/meshcore_client.dart';
import 'package:meshcore_sar_app/models/config_profile.dart';
import 'package:meshcore_sar_app/models/contact.dart';
import 'package:meshcore_sar_app/models/contact_group.dart';
import 'package:meshcore_sar_app/models/device_info.dart';
import 'package:meshcore_sar_app/providers/app_provider.dart';
import 'package:meshcore_sar_app/providers/channels_provider.dart';
import 'package:meshcore_sar_app/providers/connection_provider.dart';
import 'package:meshcore_sar_app/providers/contacts_provider.dart';
import 'package:meshcore_sar_app/providers/drawing_provider.dart';
import 'package:meshcore_sar_app/providers/map_provider.dart';
import 'package:meshcore_sar_app/providers/messages_provider.dart';
import 'package:meshcore_sar_app/services/app_config_snapshot_service.dart';
import 'package:meshcore_sar_app/services/contact_storage_service.dart';
import 'package:meshcore_sar_app/services/device_config_applicator.dart';
import 'package:meshcore_sar_app/services/message_storage_service.dart';
import 'package:meshcore_sar_app/services/profile_manager.dart';
import 'package:meshcore_sar_app/services/profile_workspace_coordinator.dart';
import 'package:meshcore_sar_app/services/profiles_feature_service.dart';
import 'package:meshcore_sar_app/services/map_workspace_snapshot_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ProfileStorageScope.setScope(
      profilesEnabled: true,
      activeProfileId: ConfigProfile.defaultProfileId,
    );
  });

  group('ProfileWorkspaceCoordinator', () {
    test(
      'createProfileFromCurrent starts with empty contacts and messages',
      () async {
        final manager = ProfileManager();
        await manager.initialize();
        await manager.setProfilesEnabled(true);

        final messageStorage = MessageStorageService();
        final contactStorage = ContactStorageService();

        await messageStorage.saveMessages([_buildMessage('default-msg')]);
        await contactStorage.saveContacts([
          _buildContact('Default Contact', 1),
        ]);
        await contactStorage.saveContactGroups([
          SavedContactGroup(
            id: 'group-1',
            sectionKey: 'manual',
            label: 'Team',
            query: '',
            createdAt: DateTime.parse('2026-03-16T12:00:00Z'),
          ),
        ]);
        await contactStorage.savePendingAdverts([
          {'id': 'pending-1'},
        ]);

        final coordinator = _buildCoordinator(profileManager: manager);

        final profile = await coordinator.createProfileFromCurrent(
          name: 'Empty Profile',
        );

        expect(
          await messageStorage.loadMessages(namespace: profile.id),
          isEmpty,
        );
        expect(
          await contactStorage.loadContacts(namespace: profile.id),
          isEmpty,
        );
        expect(
          await contactStorage.loadContactGroups(namespace: profile.id),
          isEmpty,
        );
        expect(
          await contactStorage.loadPendingAdverts(namespace: profile.id),
          isEmpty,
        );

        expect(await messageStorage.loadMessages(), hasLength(1));
        expect(await contactStorage.loadContacts(), hasLength(1));
      },
    );

    test(
      'duplicateProfile copies contacts and messages from source profile',
      () async {
        final manager = ProfileManager();
        await manager.initialize();
        await manager.setProfilesEnabled(true);

        final source = ConfigProfile(
          id: 'profile-source',
          name: 'Source',
          createdAt: DateTime.parse('2026-03-16T12:00:00Z'),
          updatedAt: DateTime.parse('2026-03-16T12:00:00Z'),
          sections: const ConfigProfileSections(),
        );
        await manager.upsertProfile(source);

        final messageStorage = MessageStorageService();
        final contactStorage = ContactStorageService();

        await messageStorage.saveMessages([
          _buildMessage('source-msg'),
        ], namespace: source.id);
        await contactStorage.saveContacts([
          _buildContact('Source Contact', 2),
        ], namespace: source.id);
        await contactStorage.saveContactGroups([
          SavedContactGroup(
            id: 'source-group',
            sectionKey: 'manual',
            label: 'Source Team',
            query: '',
            createdAt: DateTime.parse('2026-03-16T12:00:00Z'),
          ),
        ], namespace: source.id);
        await contactStorage.savePendingAdverts([
          {'id': 'source-pending'},
        ], namespace: source.id);

        final coordinator = _buildCoordinator(profileManager: manager);

        final duplicate = await coordinator.duplicateProfile(source);

        final duplicatedMessages = await messageStorage.loadMessages(
          namespace: duplicate.id,
        );
        final duplicatedContacts = await contactStorage.loadContacts(
          namespace: duplicate.id,
        );
        final duplicatedGroups = await contactStorage.loadContactGroups(
          namespace: duplicate.id,
        );
        final duplicatedPending = await contactStorage.loadPendingAdverts(
          namespace: duplicate.id,
        );

        expect(duplicatedMessages.map((item) => item.id), ['source-msg']);
        expect(duplicatedContacts.map((item) => item.advName), [
          'Source Contact',
        ]);
        expect(duplicatedGroups.map((item) => item.id), ['source-group']);
        expect(duplicatedPending, [
          {'id': 'source-pending'},
        ]);
      },
    );

    test(
      'openProfile disconnects current connection before switching',
      () async {
        final manager = ProfileManager();
        await manager.initialize();
        await manager.setProfilesEnabled(true);

        final target = ConfigProfile(
          id: 'profile-target',
          name: 'Target',
          createdAt: DateTime.parse('2026-03-16T12:00:00Z'),
          updatedAt: DateTime.parse('2026-03-16T12:00:00Z'),
          sections: const ConfigProfileSections(),
        );
        await manager.upsertProfile(target);

        final connectionProvider = _FakeConnectionProvider();
        final coordinator = _buildCoordinator(
          profileManager: manager,
          connectionProvider: connectionProvider,
        );

        await coordinator.openProfile(target.id);

        expect(connectionProvider.disconnectCallCount, 1);
        expect(manager.activeProfileId, target.id);
      },
    );
  });
}

ProfileWorkspaceCoordinator _buildCoordinator({
  required ProfileManager profileManager,
  _FakeConnectionProvider? connectionProvider,
}) {
  return ProfileWorkspaceCoordinator(
    profileManager: profileManager,
    connectionProvider: connectionProvider ?? _FakeConnectionProvider(),
    contactsProvider: _FakeContactsProvider(),
    messagesProvider: _FakeMessagesProvider(),
    mapProvider: _FakeMapProvider(),
    drawingProvider: _FakeDrawingProvider(),
    channelsProvider: _FakeChannelsProvider(),
    appProvider: _FakeAppProvider(),
    appConfigSnapshotService: _FakeAppConfigSnapshotService(),
    mapWorkspaceSnapshotService: _FakeMapWorkspaceSnapshotService(),
    deviceConfigApplicator: _FakeDeviceConfigApplicator(),
  );
}

Message _buildMessage(String id) {
  return Message(
    id: id,
    messageType: MessageType.channel,
    senderPublicKeyPrefix: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
    channelIdx: 0,
    pathLen: 0,
    textType: MessageTextType.plain,
    senderTimestamp: 1700000000,
    text: id,
    receivedAt: DateTime.fromMillisecondsSinceEpoch(1700000000500),
    isRead: true,
  );
}

Contact _buildContact(String name, int fillByte) {
  return Contact(
    publicKey: Uint8List.fromList(List<int>.filled(32, fillByte)),
    type: ContactType.chat,
    flags: 0,
    outPathLen: 0,
    outPath: Uint8List(64),
    advName: name,
    lastAdvert: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    advLat: (46.0569 * 1e6).round(),
    advLon: (14.5058 * 1e6).round(),
    lastMod: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  );
}

class _FakeAppConfigSnapshotService extends AppConfigSnapshotService {
  @override
  Future<AppSettingsProfileSection> capture(AppProvider appProvider) async {
    return const AppSettingsProfileSection();
  }
}

class _FakeMapWorkspaceSnapshotService extends MapWorkspaceSnapshotService {
  @override
  Future<MapWorkspaceProfileSection> capture({
    required MapProvider mapProvider,
    required DrawingProvider drawingProvider,
  }) async {
    return const MapWorkspaceProfileSection();
  }
}

class _FakeDeviceConfigApplicator extends DeviceConfigApplicator {
  @override
  ConfigProfileSections capture({
    required ConnectionProvider connectionProvider,
    required ChannelsProvider channelsProvider,
  }) {
    return const ConfigProfileSections();
  }
}

class _FakeConnectionProvider implements ConnectionProvider {
  int disconnectCallCount = 0;

  @override
  DeviceInfo get deviceInfo => DeviceInfo();

  @override
  Future<void> disconnect() async {
    disconnectCallCount += 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeContactsProvider implements ContactsProvider {
  @override
  Future<void> persistNow() async {}

  @override
  Future<void> reloadFromStorage({
    String? namespace,
    Uint8List? devicePublicKey,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMessagesProvider implements MessagesProvider {
  @override
  Future<void> persistNow() async {}

  @override
  Future<void> reloadFromStorage({String? namespace}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMapProvider implements MapProvider {
  @override
  Future<void> reloadProfileScopedState() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDrawingProvider implements DrawingProvider {
  @override
  Future<void> reloadProfileScopedState() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeChannelsProvider implements ChannelsProvider {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAppProvider implements AppProvider {
  @override
  Future<void> reloadProfileScopedSettings() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

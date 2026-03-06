import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshcore_sar_app/models/message.dart';
import 'package:meshcore_sar_app/models/message_contact_location.dart';
import 'package:meshcore_sar_app/providers/messages_provider.dart';
import 'package:meshcore_sar_app/utils/voice_message_parser.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MessagesProvider voice detection', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('marks VE2 envelope messages as voice', () {
      final provider = MessagesProvider();
      final envelope = VoiceEnvelope(
        sessionId: 'deafbead',
        mode: VoicePacketMode.mode1200,
        total: 3,
        durationMs: 2400,
        senderKey6: 'aabbccddeeff',
        timestampSec: 1700000000,
      );

      final message = Message(
        id: 'm1',
        messageType: MessageType.channel,
        channelIdx: 0,
        pathLen: 0,
        textType: MessageTextType.plain,
        senderTimestamp: 1700000000,
        text: envelope.encodeText(),
        receivedAt: DateTime.now(),
        senderPublicKeyPrefix: Uint8List.fromList([0, 1, 2, 3, 4, 5]),
        deliveryStatus: MessageDeliveryStatus.sent,
      );

      provider.addMessage(message);
      final stored = provider.messages.single;
      expect(stored.isVoice, isTrue);
      expect(stored.voiceId, equals('deafbead'));
    });

    test('marks legacy V text packets as voice', () {
      final provider = MessagesProvider();
      final packet = VoicePacket(
        sessionId: '00112233',
        mode: VoicePacketMode.mode700c,
        index: 0,
        total: 1,
        codec2Data: Uint8List.fromList([1, 2, 3]),
      );
      final message = Message(
        id: 'm2',
        messageType: MessageType.channel,
        channelIdx: 0,
        pathLen: 0,
        textType: MessageTextType.plain,
        senderTimestamp: 1700000001,
        text: packet.encodeText(),
        receivedAt: DateTime.now(),
        senderPublicKeyPrefix: Uint8List.fromList([0, 1, 2, 3, 4, 5]),
        deliveryStatus: MessageDeliveryStatus.sent,
      );

      provider.addMessage(message);
      final stored = provider.messages.single;
      expect(stored.isVoice, isTrue);
      expect(stored.voiceId, equals('00112233'));
    });

    test('persists received contact location snapshots', () async {
      final provider = MessagesProvider();
      final message = Message(
        id: 'm3',
        messageType: MessageType.contact,
        pathLen: 1,
        textType: MessageTextType.plain,
        senderTimestamp: 1700000002,
        text: 'status update',
        receivedAt: DateTime.now(),
        senderPublicKeyPrefix: Uint8List.fromList([0, 1, 2, 3, 4, 5]),
      );

      provider.addMessage(
        message,
        contactLocationSnapshot: MessageContactLocation(
          location: const LatLng(46.0569, 14.5058),
          source: 'advert',
          capturedAt: DateTime.now(),
          sourceTimestamp: DateTime.now(),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final restoredProvider = MessagesProvider();
      await restoredProvider.initialize();
      final snapshot = restoredProvider.getMessageContactLocation('m3');

      expect(snapshot, isNotNull);
      expect(snapshot!.source, equals('advert'));
      expect(snapshot.location.latitude, closeTo(46.0569, 0.000001));
      expect(snapshot.location.longitude, closeTo(14.5058, 0.000001));
    });
  });
}

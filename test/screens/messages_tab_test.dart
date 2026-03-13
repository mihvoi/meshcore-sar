import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshcore_sar_app/l10n/app_localizations.dart';
import 'package:meshcore_sar_app/models/message.dart';
import 'package:meshcore_sar_app/providers/app_provider.dart';
import 'package:meshcore_sar_app/providers/channels_provider.dart';
import 'package:meshcore_sar_app/providers/connection_provider.dart';
import 'package:meshcore_sar_app/providers/contacts_provider.dart';
import 'package:meshcore_sar_app/providers/drawing_provider.dart';
import 'package:meshcore_sar_app/providers/image_provider.dart' as ip;
import 'package:meshcore_sar_app/providers/map_provider.dart';
import 'package:meshcore_sar_app/providers/messages_provider.dart';
import 'package:meshcore_sar_app/providers/voice_provider.dart';
import 'package:meshcore_sar_app/screens/messages_tab.dart';
import 'package:meshcore_sar_app/services/voice_codec_service.dart';
import 'package:meshcore_sar_app/services/voice_player_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('marks public channel as read after 5 seconds of viewing', (
    tester,
  ) async {
    final connectionProvider = ConnectionProvider();
    final contactsProvider = ContactsProvider();
    final messagesProvider = MessagesProvider();
    final mapProvider = MapProvider();
    final drawingProvider = DrawingProvider();
    final channelsProvider = ChannelsProvider()..initializePublicChannel();
    final voiceProvider = VoiceProvider(
      codec: VoiceCodecService(),
      player: VoicePlayerService(),
    );
    final imageProvider = ip.ImageProvider();
    final appProvider = AppProvider(
      connectionProvider: connectionProvider,
      contactsProvider: contactsProvider,
      messagesProvider: messagesProvider,
      drawingProvider: drawingProvider,
      channelsProvider: channelsProvider,
      voiceProvider: voiceProvider,
      imageProvider: imageProvider,
    );

    messagesProvider.addMessage(
      Message(
        id: 'public-unread',
        messageType: MessageType.channel,
        pathLen: 1,
        textType: MessageTextType.plain,
        senderTimestamp: 1700000100,
        text: 'Unread on public channel',
        receivedAt: DateTime.now(),
        channelIdx: 0,
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: connectionProvider),
          ChangeNotifierProvider.value(value: contactsProvider),
          ChangeNotifierProvider.value(value: messagesProvider),
          ChangeNotifierProvider.value(value: mapProvider),
          ChangeNotifierProvider.value(value: drawingProvider),
          ChangeNotifierProvider.value(value: channelsProvider),
          ChangeNotifierProvider.value(value: voiceProvider),
          ChangeNotifierProvider.value(value: imageProvider),
          ChangeNotifierProvider.value(value: appProvider),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: MessagesTab(isActive: true)),
        ),
      ),
    );

    await tester.pump();

    expect(messagesProvider.unreadCount, 1);

    await tester.pump(const Duration(seconds: 4));
    expect(messagesProvider.unreadCount, 1);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(messagesProvider.unreadCount, 0);

    appProvider.dispose();
    voiceProvider.dispose();
    imageProvider.dispose();
    drawingProvider.dispose();
    mapProvider.dispose();
    messagesProvider.dispose();
    contactsProvider.dispose();
    connectionProvider.dispose();
    channelsProvider.dispose();
  });
}

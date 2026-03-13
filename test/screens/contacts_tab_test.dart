import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshcore_sar_app/l10n/app_localizations.dart';
import 'package:meshcore_sar_app/models/contact.dart';
import 'package:meshcore_sar_app/providers/connection_provider.dart';
import 'package:meshcore_sar_app/providers/contacts_provider.dart';
import 'package:meshcore_sar_app/providers/map_provider.dart';
import 'package:meshcore_sar_app/providers/messages_provider.dart';
import 'package:meshcore_sar_app/screens/contacts_tab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Contact buildChannel({required String name, required int channelIndex}) {
    final publicKey = Uint8List(32);
    publicKey[0] = 0xFF;
    publicKey[1] = channelIndex;

    return Contact(
      publicKey: publicKey,
      type: ContactType.channel,
      flags: 0,
      outPathLen: -1,
      outPath: Uint8List(0),
      advName: name,
      lastAdvert: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      advLat: 0,
      advLon: 0,
      lastMod: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  Future<void> pumpContactsTab(
    WidgetTester tester, {
    required List<Contact> channels,
  }) async {
    final contactsProvider = ContactsProvider();
    for (final channel in channels) {
      contactsProvider.addOrUpdateContact(channel);
    }

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: contactsProvider),
          ChangeNotifierProvider(create: (_) => ConnectionProvider()),
          ChangeNotifierProvider(create: (_) => MessagesProvider()),
          ChangeNotifierProvider(create: (_) => MapProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ContactsTab()),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('private channel activity card shows delete action in sheet', (
    tester,
  ) async {
    await pumpContactsTab(
      tester,
      channels: [buildChannel(name: 'Ops', channelIndex: 3)],
    );

    expect(find.text('Ops'), findsOneWidget);
    await tester.tap(find.text('Ops'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Channel'), findsOneWidget);

    await tester.tap(find.text('Delete Channel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Channel'), findsWidgets);
    expect(
      find.text(
        'Are you sure you want to delete channel "Ops"? This action cannot be undone.',
      ),
      findsOneWidget,
    );
  });
}

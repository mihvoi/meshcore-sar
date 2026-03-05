import 'package:flutter_test/flutter_test.dart';
import 'package:meshcore_sar_app/providers/helpers/session_metadata_restore.dart';
import 'package:meshcore_sar_app/utils/image_message_parser.dart';
import 'package:meshcore_sar_app/utils/voice_message_parser.dart';

void main() {
  group('restoreSessionMetadataFromMessages', () {
    test(
      'restores voice and image session senders from persisted envelopes',
      () {
        final voiceEnvelope = VoiceEnvelope(
          sessionId: '00112233',
          mode: VoicePacketMode.mode1200,
          total: 4,
          durationMs: 4000,
          senderKey6: 'AABBCCDDEEFF',
          timestampSec: 123456,
        );
        final imageEnvelope = ImageEnvelope(
          sessionId: '195cb2fb',
          format: ImageFormat.avif,
          total: 7,
          width: 118,
          height: 256,
          sizeBytes: 1069,
          senderKey6: 'FE8B30EE05FC',
          timestampSec: 123457,
        );

        final restored = restoreSessionMetadataFromMessages([
          'plain text',
          voiceEnvelope.encodeText(),
          imageEnvelope.encode(),
        ]);

        expect(
          restored.voiceSenderKeyBySession,
          equals({'00112233': 'aabbccddeeff'}),
        );
        expect(restored.imageEnvelopeBySession.keys, equals({'195cb2fb'}));
        expect(
          restored.imageEnvelopeBySession['195cb2fb']?.senderKey6,
          equals('fe8b30ee05fc'),
        );
      },
    );

    test('keeps latest envelope when a session appears multiple times', () {
      final first = ImageEnvelope(
        sessionId: '195cb2fb',
        format: ImageFormat.avif,
        total: 7,
        width: 100,
        height: 100,
        sizeBytes: 900,
        senderKey6: '001122334455',
        timestampSec: 100,
      );
      final second = ImageEnvelope(
        sessionId: '195cb2fb',
        format: ImageFormat.jpeg,
        total: 8,
        width: 118,
        height: 256,
        sizeBytes: 1069,
        senderKey6: 'AABBCCDDEEFF',
        timestampSec: 101,
      );

      final restored = restoreSessionMetadataFromMessages([
        first.encode(),
        second.encode(),
      ]);

      expect(restored.imageEnvelopeBySession.length, equals(1));
      expect(
        restored.imageEnvelopeBySession['195cb2fb']?.senderKey6,
        equals('aabbccddeeff'),
      );
      expect(
        restored.imageEnvelopeBySession['195cb2fb']?.format,
        equals(ImageFormat.jpeg),
      );
    });
  });
}

import '../../utils/image_message_parser.dart';
import '../../utils/voice_message_parser.dart';

class RestoredSessionMetadata {
  final Map<String, String> voiceSenderKeyBySession;
  final Map<String, ImageEnvelope> imageEnvelopeBySession;

  const RestoredSessionMetadata({
    required this.voiceSenderKeyBySession,
    required this.imageEnvelopeBySession,
  });
}

RestoredSessionMetadata restoreSessionMetadataFromMessages(
  Iterable<String> messageTexts,
) {
  final voiceSenderKeyBySession = <String, String>{};
  final imageEnvelopeBySession = <String, ImageEnvelope>{};

  for (final text in messageTexts) {
    final voiceEnvelope = VoiceEnvelope.tryParseText(text);
    if (voiceEnvelope != null) {
      voiceSenderKeyBySession[voiceEnvelope.sessionId] = voiceEnvelope
          .senderKey6
          .toLowerCase();
    }

    final imageEnvelope = ImageEnvelope.tryParse(text);
    if (imageEnvelope != null) {
      imageEnvelopeBySession[imageEnvelope.sessionId] = imageEnvelope;
    }
  }

  return RestoredSessionMetadata(
    voiceSenderKeyBySession: voiceSenderKeyBySession,
    imageEnvelopeBySession: imageEnvelopeBySession,
  );
}

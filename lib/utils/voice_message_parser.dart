import 'dart:convert';
import 'dart:typed_data';

/// Identifies which Codec2 mode was used for a voice packet.
/// Matches the modeId byte in the text/binary packet header.
enum VoicePacketMode {
  mode700c(0, '700C'),
  mode1200(1, '1200'),
  mode2400(2, '2400'),
  mode1300(3, '1300');

  const VoicePacketMode(this.id, this.label);
  final int id;
  final String label;

  static VoicePacketMode fromId(int id) =>
      VoicePacketMode.values.firstWhere((m) => m.id == id, orElse: () => VoicePacketMode.mode700c);
}

/// A single Codec2-encoded chunk belonging to a multi-packet voice session.
///
/// Text format (channels):
///   V:{sessionId8hex}:{modeId}:{index}/{total}:{base64Codec2}
///
/// Binary format (direct contacts, received via pushRawData):
///   [0x56 'V'][sessionId:4B][modeId:1B][index:1B][total:1B][codec2Data...]
class VoicePacket {
  final String sessionId; // 8 hex chars (4 bytes)
  final VoicePacketMode mode;
  final int index;         // 0-based
  final int total;         // total packet count
  final Uint8List codec2Data;

  const VoicePacket({
    required this.sessionId,
    required this.mode,
    required this.index,
    required this.total,
    required this.codec2Data,
  });

  // ── Text (channel) format ────────────────────────────────────────────────

  static const String _textPrefix = 'V:';

  static bool isVoiceText(String text) => text.startsWith(_textPrefix);

  /// Parse a text-format voice packet.  Returns null on failure.
  static VoicePacket? tryParseText(String text) {
    if (!text.startsWith(_textPrefix)) return null;
    try {
      final body = text.substring(_textPrefix.length);
      final parts = body.split(':');
      // parts: [sessionId, modeId, 'idx/total', base64data]
      if (parts.length != 4) return null;

      final sessionId = parts[0];
      if (sessionId.length != 8) return null;

      final modeId = int.tryParse(parts[1]);
      if (modeId == null) return null;

      final indexTotal = parts[2].split('/');
      if (indexTotal.length != 2) return null;
      final index = int.tryParse(indexTotal[0]);
      final total = int.tryParse(indexTotal[1]);
      if (index == null || total == null || total < 1) return null;

      final codec2Data = base64.decode(parts[3]);

      return VoicePacket(
        sessionId: sessionId,
        mode: VoicePacketMode.fromId(modeId),
        index: index,
        total: total,
        codec2Data: codec2Data,
      );
    } catch (_) {
      return null;
    }
  }

  /// Encode as text (channel format).  Max ~198 chars for 700C/1200/2400.
  String encodeText() {
    final b64 = base64.encode(codec2Data);
    return 'V:$sessionId:${mode.id}:$index/$total:$b64';
  }

  // ── Binary format ────────────────────────────────────────────────────────

  static const int _binaryMagic = 0x56; // 'V'
  static const int _binaryHeaderLen = 8; // magic(1)+session(4)+mode(1)+idx(1)+total(1)

  static bool isVoiceBinary(Uint8List payload) =>
      payload.isNotEmpty && payload[0] == _binaryMagic;

  /// Parse binary-format voice packet (from pushRawData payload).
  static VoicePacket? tryParseBinary(Uint8List payload) {
    if (payload.length < _binaryHeaderLen) return null;
    if (payload[0] != _binaryMagic) return null;
    try {
      final sessionBytes = payload.sublist(1, 5);
      final sessionId = sessionBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      final modeId = payload[5];
      final index  = payload[6];
      final total  = payload[7];
      if (total < 1) return null;
      final codec2Data = payload.sublist(_binaryHeaderLen);
      return VoicePacket(
        sessionId: sessionId,
        mode: VoicePacketMode.fromId(modeId),
        index: index,
        total: total,
        codec2Data: codec2Data,
      );
    } catch (_) {
      return null;
    }
  }

  /// Encode as binary payload (for cmdSendRawData).
  Uint8List encodeBinary() {
    final sessionBytes = Uint8List(4);
    for (var i = 0; i < 4; i++) {
      sessionBytes[i] = int.parse(sessionId.substring(i * 2, i * 2 + 2), radix: 16);
    }
    final out = Uint8List(_binaryHeaderLen + codec2Data.length);
    out[0] = _binaryMagic;
    out.setRange(1, 5, sessionBytes);
    out[5] = mode.id;
    out[6] = index;
    out[7] = total;
    out.setRange(_binaryHeaderLen, out.length, codec2Data);
    return out;
  }

  // ── Duration helpers ─────────────────────────────────────────────────────

  /// Estimated audio duration of this packet in milliseconds.
  int get durationMs {
    // bytesPerSecond for each mode
    final bps = switch (mode) {
      VoicePacketMode.mode700c => 100,
      VoicePacketMode.mode1200 => 150,
      VoicePacketMode.mode1300 => 175,
      VoicePacketMode.mode2400 => 300,
    };
    if (bps == 0) return 0;
    return (codec2Data.length * 1000 ~/ bps).clamp(0, 1500);
  }

  @override
  String toString() =>
      'VoicePacket($sessionId ${mode.label} [$index/${total - 1}] ${codec2Data.length}B)';
}

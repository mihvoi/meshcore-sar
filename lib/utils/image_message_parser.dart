import 'dart:typed_data';

/// Compressed image format used in the image packet protocol.
enum ImageFormat {
  avif(0, 'AVIF'),
  jpeg(1, 'JPEG');

  const ImageFormat(this.id, this.label);
  final int id;
  final String label;

  static ImageFormat fromId(int id) => ImageFormat.values.firstWhere(
    (f) => f.id == id,
    orElse: () => ImageFormat.avif,
  );
}

/// A single binary fragment of a compressed image.
///
/// Binary format (direct contacts, via pushRawData / cmdSendRawData):
///   [0x49 'I'][sessionId:4B][fmt:1B][idx:1B][total:1B][imageData...]
///
/// Max total packet size is 160 bytes → 152 bytes of image data per fragment.
class ImagePacket {
  final String sessionId; // 8 hex chars (4 bytes)
  final ImageFormat format;
  final int index; // 0-based
  final int total; // total fragment count (1..255)
  final Uint8List data;

  const ImagePacket({
    required this.sessionId,
    required this.format,
    required this.index,
    required this.total,
    required this.data,
  });

  static const int _magic = 0x49; // 'I'
  static const int _headerLen = 8; // magic(1)+session(4)+fmt(1)+idx(1)+total(1)
  static const int maxDataBytes = 152; // 160 - 8 header bytes

  static bool isImageBinary(Uint8List payload) =>
      payload.isNotEmpty && payload[0] == _magic;

  static ImagePacket? tryParseBinary(Uint8List payload) {
    if (payload.length < _headerLen) return null;
    if (payload[0] != _magic) return null;
    try {
      final sessionId = payload
          .sublist(1, 5)
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
      final fmtId = payload[5];
      final index = payload[6];
      final total = payload[7];
      if (total < 1) return null;
      return ImagePacket(
        sessionId: sessionId,
        format: ImageFormat.fromId(fmtId),
        index: index,
        total: total,
        data: payload.sublist(_headerLen),
      );
    } catch (_) {
      return null;
    }
  }

  Uint8List encodeBinary() {
    final sessionBytes = Uint8List(4);
    for (var i = 0; i < 4; i++) {
      sessionBytes[i] = int.parse(
        sessionId.substring(i * 2, i * 2 + 2),
        radix: 16,
      );
    }
    final out = Uint8List(_headerLen + data.length);
    out[0] = _magic;
    out.setRange(1, 5, sessionBytes);
    out[5] = format.id;
    out[6] = index;
    out[7] = total;
    out.setRange(_headerLen, out.length, data);
    return out;
  }

  @override
  String toString() =>
      'ImagePacket($sessionId ${format.label} [$index/${total - 1}] ${data.length}B)';
}

/// Envelope announcing image availability (control plane).
///
/// Text format:
///   IE1:{sid}:{fmt}:{total}:{w}:{h}:{bytes}:{senderKey6}:{ts}:{ver}
/// Example:
///   IE1:deadbeef:0:7:128:128:1050:aabbccddeeff:1700000000:1
class ImageEnvelope {
  static const String prefix = 'IE1:';

  final String sessionId; // 8 hex chars
  final ImageFormat format;
  final int total; // total fragment count
  final int width;
  final int height;
  final int sizeBytes; // total compressed image size
  final String senderKey6; // 12 hex chars (6 bytes)
  final int timestampSec;
  final int version;

  const ImageEnvelope({
    required this.sessionId,
    required this.format,
    required this.total,
    required this.width,
    required this.height,
    required this.sizeBytes,
    required this.senderKey6,
    required this.timestampSec,
    this.version = 1,
  });

  static bool isEnvelope(String text) => text.startsWith(prefix);

  static ImageEnvelope? tryParse(String text) {
    if (!isEnvelope(text)) return null;
    final body = text.substring(prefix.length);
    final parts = body.split(':');
    if (parts.length != 9) return null;
    try {
      final sid = parts[0];
      final fmtId = int.tryParse(parts[1]);
      final total = int.tryParse(parts[2]);
      final w = int.tryParse(parts[3]);
      final h = int.tryParse(parts[4]);
      final bytes = int.tryParse(parts[5]);
      final senderKey6 = parts[6];
      final ts = int.tryParse(parts[7]);
      final ver = int.tryParse(parts[8]);

      if (!RegExp(r'^[0-9a-fA-F]{8}$').hasMatch(sid)) return null;
      if (fmtId == null) return null;
      if (total == null || total < 1 || total > 255) return null;
      if (w == null || h == null || w < 1 || h < 1) return null;
      if (bytes == null || bytes < 1) return null;
      if (!RegExp(r'^[0-9a-fA-F]{12}$').hasMatch(senderKey6)) return null;
      if (ts == null || ts <= 0) return null;
      if (ver == null || ver != 1) return null;

      return ImageEnvelope(
        sessionId: sid.toLowerCase(),
        format: ImageFormat.fromId(fmtId),
        total: total,
        width: w,
        height: h,
        sizeBytes: bytes,
        senderKey6: senderKey6.toLowerCase(),
        timestampSec: ts,
        version: ver,
      );
    } catch (_) {
      return null;
    }
  }

  String encode() =>
      '${prefix}${sessionId.toLowerCase()}:${format.id}:$total:$width:$height:$sizeBytes:${senderKey6.toLowerCase()}:$timestampSec:$version';
}

/// Direct request to fetch image fragments (control plane).
///
/// Text format:
///   IR1:{sid}:{want}:{requesterKey6}:{ts}:{ver}
/// Example:
///   IR1:deadbeef:a:aabbccddeeff:1700000010:1
class ImageFetchRequest {
  static const String prefix = 'IR1:';

  final String sessionId;
  final String want; // always 'all'
  final String requesterKey6; // 12 hex chars
  final int timestampSec;
  final int version;

  const ImageFetchRequest({
    required this.sessionId,
    this.want = 'all',
    required this.requesterKey6,
    required this.timestampSec,
    this.version = 1,
  });

  static bool isRequest(String text) => text.startsWith(prefix);

  static ImageFetchRequest? tryParse(String text) {
    if (!isRequest(text)) return null;
    final body = text.substring(prefix.length);
    final parts = body.split(':');
    if (parts.length != 5) return null;
    try {
      final sid = parts[0];
      final wantToken = parts[1];
      final requesterKey6 = parts[2];
      final ts = int.tryParse(parts[3]);
      final ver = int.tryParse(parts[4]);
      final normalizedWant = wantToken == 'a' ? 'all' : wantToken;

      if (!RegExp(r'^[0-9a-fA-F]{8}$').hasMatch(sid)) return null;
      if (normalizedWant != 'all') return null;
      if (!RegExp(r'^[0-9a-fA-F]{12}$').hasMatch(requesterKey6)) return null;
      if (ts == null || ts <= 0) return null;
      if (ver == null || ver != 1) return null;

      return ImageFetchRequest(
        sessionId: sid.toLowerCase(),
        want: normalizedWant,
        requesterKey6: requesterKey6.toLowerCase(),
        timestampSec: ts,
        version: ver,
      );
    } catch (_) {
      return null;
    }
  }

  String encode() {
    final wantToken = want == 'all' ? 'a' : want;
    return '${prefix}${sessionId.toLowerCase()}:$wantToken:${requesterKey6.toLowerCase()}:$timestampSec:$version';
  }
}

/// Fragment the compressed image bytes into [ImagePacket] list.
///
/// [sessionId] must be 8 lowercase hex chars.
/// [format] is the image format used.
/// Returns at most 255 packets; excess bytes are silently dropped.
List<ImagePacket> fragmentImage({
  required String sessionId,
  required ImageFormat format,
  required Uint8List bytes,
}) {
  const chunkSize = ImagePacket.maxDataBytes;
  final chunks = <Uint8List>[];
  for (var offset = 0; offset < bytes.length; offset += chunkSize) {
    final end = (offset + chunkSize).clamp(0, bytes.length);
    chunks.add(bytes.sublist(offset, end));
    if (chunks.length == 255) break; // protocol limit
  }
  final total = chunks.length;
  return [
    for (var i = 0; i < total; i++)
      ImagePacket(
        sessionId: sessionId,
        format: format,
        index: i,
        total: total,
        data: chunks[i],
      ),
  ];
}

/// Reassemble image bytes from received [packets].
///
/// Returns null if any fragment is missing.
Uint8List? reassembleImage(List<ImagePacket?> packets) {
  if (packets.isEmpty) return null;
  if (packets.any((p) => p == null)) return null;
  final merged = <int>[];
  for (final p in packets) {
    merged.addAll(p!.data);
  }
  return Uint8List.fromList(merged);
}

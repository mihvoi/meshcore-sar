import 'dart:typed_data';
import 'package:codec2_flutter/codec2_flutter.dart';
import 'package:flutter/foundation.dart';
import '../utils/voice_message_parser.dart';

export 'package:codec2_flutter/codec2_flutter.dart' show Codec2Mode;

/// Maps [VoicePacketMode] to the [Codec2Mode] enum from the FFI plugin.
Codec2Mode codec2ModeFor(VoicePacketMode pktMode) {
  switch (pktMode) {
    case VoicePacketMode.mode3200: return Codec2Mode.mode3200;
    case VoicePacketMode.mode1600: return Codec2Mode.mode1600;
    case VoicePacketMode.mode1400: return Codec2Mode.mode1400;
    case VoicePacketMode.mode700c: return Codec2Mode.mode700c;
    case VoicePacketMode.mode1200: return Codec2Mode.mode1200;
    case VoicePacketMode.mode1300: return Codec2Mode.mode1300;
    case VoicePacketMode.mode2400: return Codec2Mode.mode2400;
  }
}

/// Selects the [VoicePacketMode] best suited for a given LoRa radio bandwidth.
///
/// Call with [radioBandwidthHz] from the device's radio params
/// (e.g. 125000 for 125 kHz).
VoicePacketMode voiceModeForBandwidth(int radioBandwidthHz) {
  if (radioBandwidthHz <= 62500) return VoicePacketMode.mode700c;
  if (radioBandwidthHz <= 125000) return VoicePacketMode.mode1200;
  return VoicePacketMode.mode1300;
}

/// High-level codec service that provides async Codec2 encode/decode
/// executed in a background isolate so the UI thread is never blocked.
class VoiceCodecService {
  void _ensureCodec2Supported() {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      throw UnsupportedError('Codec2 is enabled only on iOS and Android.');
    }
  }

  /// Encode [pcm] (Int16 samples, 8000 Hz mono) with [mode].
  /// Returns the raw Codec2-encoded bytes.
  Future<Uint8List> encode(Int16List pcm, VoicePacketMode mode) {
    _ensureCodec2Supported();
    return Codec2.encodeInIsolate(pcm, codec2ModeFor(mode));
  }

  /// Decode [codec2Bytes] back to Int16 PCM (8000 Hz mono) with [mode].
  Future<Int16List> decode(Uint8List codec2Bytes, VoicePacketMode mode) {
    _ensureCodec2Supported();
    return Codec2.decodeInIsolate(codec2Bytes, codec2ModeFor(mode));
  }

  /// Decode and concatenate multiple [packets] into a single PCM Int16List.
  /// Packets with null/missing entries are substituted with silence.
  Future<Int16List> decodePackets(
    List<VoicePacket?> packets,
    VoicePacketMode mode,
  ) async {
    _ensureCodec2Supported();
    final c2Mode = codec2ModeFor(mode);
    final c2 = Codec2.create(c2Mode);
    final spf = c2.samplesPerFrame;
    c2.destroy();

    // Estimate total samples (use actual data or silence per missing packet)
    final all = <Int16List>[];
    for (final pkt in packets) {
      if (pkt == null || pkt.codec2Data.isEmpty) {
        // Silence for missing packet — duration approximated by mode
        final silenceSamples = (codec2ModeFor(mode).framesPerSecond) * spf;
        all.add(Int16List(silenceSamples));
      } else {
        final decoded = await Codec2.decodeInIsolate(pkt.codec2Data, c2Mode);
        all.add(decoded);
      }
    }

    final total = all.fold<int>(0, (sum, l) => sum + l.length);
    final result = Int16List(total);
    var offset = 0;
    for (final chunk in all) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return result;
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Plays decoded 8000 Hz / 16-bit mono PCM samples by writing a WAV file
/// to the system temp directory and using [AudioPlayer].
class VoicePlayerService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  VoicePlayerService() {
    _player.onPlayerStateChanged.listen((state) {
      debugPrint('🔊 [VoicePlayer] state → $state');
      _isPlaying = state == PlayerState.playing;
    });
    _player.onLog.listen((msg) => debugPrint('🔊 [VoicePlayer] log: $msg'));
  }

  /// Play [pcmSamples] (Int16, 8000 Hz, mono).
  Future<void> play(Int16List pcmSamples) async {
    debugPrint('🔊 [VoicePlayer] play() called, ${pcmSamples.length} samples');
    if (_isPlaying) await stop();

    final wavBytes = _buildWav(pcmSamples, sampleRate: 8000);
    final tmpDir = await getTemporaryDirectory();
    final file = File('${tmpDir.path}/vc_voice.wav');
    await file.writeAsBytes(wavBytes);
    debugPrint('🔊 [VoicePlayer] WAV written: ${wavBytes.length} bytes → ${file.path}');

    try {
      _isPlaying = true;
      await _player.play(DeviceFileSource(file.path));
      debugPrint('🔊 [VoicePlayer] play() returned (audio playing)');
    } catch (e, st) {
      debugPrint('❌ [VoicePlayer] play() error: $e\n$st');
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    debugPrint('🔊 [VoicePlayer] stop()');
    await _player.stop();
    _isPlaying = false;
  }

  void dispose() {
    _player.dispose();
  }

  // ── WAV file builder ─────────────────────────────────────────────────────

  /// Constructs a minimal WAV (RIFF/PCM) file from Int16 mono samples.
  static Uint8List _buildWav(Int16List samples, {required int sampleRate}) {
    const int numChannels  = 1;
    const int bitsPerSample = 16;
    const int audioFormat  = 1; // PCM

    final dataSize   = samples.length * 2; // 2 bytes per Int16 sample
    final byteRate   = sampleRate * numChannels * bitsPerSample ~/ 8;
    final blockAlign = numChannels * bitsPerSample ~/ 8;
    final totalSize  = 36 + dataSize;

    final buf = ByteData(44 + dataSize);
    var offset = 0;

    void writeStr(String s) {
      for (final c in s.codeUnits) { buf.setUint8(offset++, c); }
    }
    void writeU32(int v) { buf.setUint32(offset, v, Endian.little); offset += 4; }
    void writeU16(int v) { buf.setUint16(offset, v, Endian.little); offset += 2; }

    writeStr('RIFF');
    writeU32(totalSize);
    writeStr('WAVE');
    writeStr('fmt ');
    writeU32(16);           // subchunk1 size
    writeU16(audioFormat);  // 1 = PCM
    writeU16(numChannels);
    writeU32(sampleRate);
    writeU32(byteRate);
    writeU16(blockAlign);
    writeU16(bitsPerSample);
    writeStr('data');
    writeU32(dataSize);

    // PCM sample data (little-endian Int16)
    for (final s in samples) {
      buf.setInt16(offset, s, Endian.little);
      offset += 2;
    }

    return buf.buffer.asUint8List();
  }
}

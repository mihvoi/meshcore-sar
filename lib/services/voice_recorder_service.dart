import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

/// Captures raw PCM audio at 8000 Hz, 16-bit mono.
///
/// [startCapture] returns a [Stream<Int16List>] that emits chunks of PCM
/// samples every [chunkDuration].  Call [stopCapture] to end recording.
class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _sub;
  StreamController<Int16List>? _controller;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  /// Request microphone permission.  Returns true if granted.
  Future<bool> requestPermission() async {
    return _recorder.hasPermission();
  }

  /// Start capturing PCM audio.
  ///
  /// [chunkDuration] controls how often samples are emitted (default 1 s).
  /// The returned stream emits [Int16List] chunks that are ready for Codec2 encoding.
  Stream<Int16List> startCapture({
    Duration chunkDuration = const Duration(seconds: 1),
  }) {
    if (_isRecording) {
      throw StateError('VoiceRecorderService: already recording');
    }

    _controller = StreamController<Int16List>(
      onCancel: () => _stopInternal(),
    );
    _isRecording = true;

    _startRecording(chunkDuration);
    return _controller!.stream;
  }

  Future<void> _startRecording(Duration chunkDuration) async {
    final config = const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 8000,
      numChannels: 1,
      bitRate: 128000, // ignored for PCM, but required by API
    );

    try {
      final stream = await _recorder.startStream(config);
      final chunkBytes = 8000 * 2 * chunkDuration.inMilliseconds ~/ 1000;
      final buffer = <int>[];

      _sub = stream.listen(
        (data) {
          buffer.addAll(data);
          while (buffer.length >= chunkBytes) {
            final chunk = buffer.sublist(0, chunkBytes);
            buffer.removeRange(0, chunkBytes);
            _controller?.add(_bytesToInt16(Uint8List.fromList(chunk)));
          }
        },
        onDone: () {
          if (buffer.isNotEmpty) {
            final padded = _padToEven(buffer);
            _controller?.add(_bytesToInt16(Uint8List.fromList(padded)));
          }
          _controller?.close();
        },
        onError: (e) {
          debugPrint('❌ [VoiceRecorder] Stream error: $e');
          _controller?.addError(e);
          _controller?.close();
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('❌ [VoiceRecorder] Failed to start: $e');
      _isRecording = false;
      _controller?.addError(e);
      _controller?.close();
    }
  }

  /// Stop recording and flush remaining samples.
  Future<void> stopCapture() async {
    await _stopInternal();
  }

  Future<void> _stopInternal() async {
    if (!_isRecording) return;
    _isRecording = false;
    await _sub?.cancel();
    _sub = null;
    await _recorder.stop();
  }

  void dispose() {
    _stopInternal();
    _recorder.dispose();
  }

  /// Convert raw little-endian PCM bytes to Int16List.
  static Int16List _bytesToInt16(Uint8List bytes) {
    final bd = ByteData.sublistView(bytes);
    final samples = Int16List(bytes.length ~/ 2);
    for (var i = 0; i < samples.length; i++) {
      samples[i] = bd.getInt16(i * 2, Endian.little);
    }
    return samples;
  }

  static List<int> _padToEven(List<int> buf) {
    if (buf.length % 2 != 0) buf.add(0);
    return buf;
  }
}

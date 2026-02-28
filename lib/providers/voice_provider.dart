import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/voice_message_parser.dart';
import '../services/voice_codec_service.dart';
import '../services/voice_player_service.dart';

/// Reassembly state for one voice session.
class VoiceSession {
  final String sessionId;
  final VoicePacketMode mode;
  final int total;
  final List<VoicePacket?> packets; // indexed by packet.index

  VoiceSession({
    required this.sessionId,
    required this.mode,
    required this.total,
  }) : packets = List.filled(total, null);

  int get receivedCount => packets.where((p) => p != null).length;
  bool get isComplete => receivedCount == total;

  /// Total estimated audio duration in seconds (sum of all received packets).
  double get estimatedDurationSeconds {
    var ms = 0;
    for (final p in packets) {
      if (p != null) ms += p.durationMs;
    }
    return ms / 1000.0;
  }
}

/// Manages incoming voice packet sessions and coordinates playback.
class VoiceProvider with ChangeNotifier {
  final VoiceCodecService _codec;
  final VoicePlayerService _player;

  /// Active sessions keyed by sessionId.
  final Map<String, VoiceSession> _sessions = {};

  /// Currently playing session ID, or null.
  String? _playingSessionId;

  VoiceProvider({
    required VoiceCodecService codec,
    required VoicePlayerService player,
  })  : _codec = codec,
        _player = player;

  // ── Session accessors ────────────────────────────────────────────────────

  VoiceSession? session(String sessionId) => _sessions[sessionId];
  bool isComplete(String sessionId) => _sessions[sessionId]?.isComplete ?? false;
  bool isPlaying(String sessionId) =>
      _playingSessionId == sessionId && _player.isPlaying;

  // ── Packet reception ─────────────────────────────────────────────────────

  /// Add an incoming [packet] to its session.  Creates the session on first packet.
  /// Returns true if the session just became complete.
  bool addPacket(VoicePacket packet) {
    _sessions.putIfAbsent(
      packet.sessionId,
      () => VoiceSession(
        sessionId: packet.sessionId,
        mode: packet.mode,
        total: packet.total,
      ),
    );

    final session = _sessions[packet.sessionId]!;
    if (packet.index < session.total) {
      session.packets[packet.index] = packet;
    }

    final justComplete = session.isComplete;
    notifyListeners();
    return justComplete;
  }

  // ── Playback ─────────────────────────────────────────────────────────────

  /// Decode and play the voice session with [sessionId].
  /// Plays whatever packets are available (handles partial reception gracefully).
  Future<void> play(String sessionId) async {
    final session = _sessions[sessionId];
    if (session == null) {
      debugPrint('❌ [VoiceProvider] play($sessionId) — session not found, known: ${_sessions.keys.toList()}');
      return;
    }

    debugPrint('🎙️ [VoiceProvider] play($sessionId): ${session.receivedCount}/${session.total} packets, mode=${session.mode.label}');

    try {
      final pcm = await _codec.decodePackets(session.packets, session.mode);
      debugPrint('🎙️ [VoiceProvider] decoded ${pcm.length} PCM samples');
      _playingSessionId = sessionId;
      notifyListeners();
      await _player.play(pcm);
    } catch (e, st) {
      debugPrint('❌ [VoiceProvider] Playback error: $e\n$st');
    } finally {
      if (_playingSessionId == sessionId) {
        _playingSessionId = null;
        notifyListeners();
      }
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _playingSessionId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

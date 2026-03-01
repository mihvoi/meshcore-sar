import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import '../utils/image_message_parser.dart';

/// Reassembly state for one incoming image session.
class ImageSession {
  final String sessionId;
  final ImageFormat format;
  final int total;
  final int width;
  final int height;
  final List<ImagePacket?> fragments; // indexed by fragment.index

  ImageSession({
    required this.sessionId,
    required this.format,
    required this.total,
    required this.width,
    required this.height,
  }) : fragments = List.filled(total, null);

  int get receivedCount => fragments.where((f) => f != null).length;
  bool get isComplete => receivedCount == total;

  /// Reassemble the complete image bytes, or null if any fragment is missing.
  Uint8List? get imageBytes => reassembleImage(fragments);
}

/// Manages incoming image sessions and outgoing image caches.
///
/// Mirrors [VoiceProvider] in architecture: on-demand fetch, deferred serving,
/// persistent storage of both incoming and outgoing session data.
class ImageProvider with ChangeNotifier {
  static const String _storageKey = 'stored_image_sessions_v1';
  static const Duration _outgoingTtl = Duration(minutes: 15);

  /// Incoming sessions keyed by sessionId.
  final Map<String, ImageSession> _sessions = {};

  /// Outgoing sessions cached for deferred serving.
  final Map<String, _OutgoingSession> _outgoing = {};

  /// Hook for sending a raw binary payload to a contact.
  Future<void> Function({
    required Uint8List contactPath,
    required int contactPathLen,
    required Uint8List payload,
  })?
  sendRawPacketCallback;

  ImageProvider() {
    _restore();
  }

  // ── Accessors ────────────────────────────────────────────────────────────

  ImageSession? session(String sessionId) => _sessions[sessionId];
  bool isComplete(String sessionId) =>
      _sessions[sessionId]?.isComplete ?? false;
  bool hasOutgoing(String sessionId) => _outgoing.containsKey(sessionId);

  // ── Incoming fragment reception ──────────────────────────────────────────

  /// Add a received [fragment].  Creates the session on first fragment using
  /// metadata from the fragment itself (requires envelope to have been
  /// announced first; if not, defaults width/height to 0 — corrected on save).
  ///
  /// Returns true when the session just became complete.
  bool addFragment(ImagePacket fragment, {int width = 0, int height = 0}) {
    _sessions.putIfAbsent(
      fragment.sessionId,
      () => ImageSession(
        sessionId: fragment.sessionId,
        format: fragment.format,
        total: fragment.total,
        width: width,
        height: height,
      ),
    );

    final session = _sessions[fragment.sessionId]!;
    if (fragment.index < session.total) {
      session.fragments[fragment.index] = fragment;
    }

    final justComplete = session.isComplete;
    unawaited(_persist());
    notifyListeners();
    return justComplete;
  }

  /// Register envelope metadata for a session (called when IE1 is received
  /// before any binary fragments arrive).
  void registerEnvelope(ImageEnvelope envelope) {
    _sessions.putIfAbsent(
      envelope.sessionId,
      () => ImageSession(
        sessionId: envelope.sessionId,
        format: envelope.format,
        total: envelope.total,
        width: envelope.width,
        height: envelope.height,
      ),
    );
    // Update dimensions if we created the session from a fragment (w/h = 0).
    final session = _sessions[envelope.sessionId]!;
    if (session.width == 0 || session.height == 0) {
      _sessions[envelope.sessionId] = ImageSession(
        sessionId: envelope.sessionId,
        format: envelope.format,
        total: envelope.total,
        width: envelope.width,
        height: envelope.height,
      );
      // Copy existing fragments into the new session.
      final old = _sessions[envelope.sessionId]!;
      for (var i = 0; i < session.fragments.length && i < old.total; i++) {
        old.fragments[i] = session.fragments[i];
      }
    }
    notifyListeners();
  }

  // ── Outgoing session management ──────────────────────────────────────────

  /// Cache encoded fragments for deferred serving.
  ///
  /// Also registers the session as complete in [_sessions] so the local
  /// bubble can display the sent image immediately without a fetch round-trip.
  void cacheOutgoingSession(
    String sessionId,
    List<ImagePacket> fragments,
    ImageEnvelope envelope,
  ) {
    if (fragments.isEmpty) return;
    _evictExpiredOutgoing();
    _outgoing[sessionId] = _OutgoingSession(
      sessionId: sessionId,
      fragments: List<ImagePacket>.from(fragments),
      envelope: envelope,
      cachedAt: DateTime.now(),
    );

    // Populate incoming session so the bubble shows the image right away.
    final session = ImageSession(
      sessionId: sessionId,
      format: envelope.format,
      total: fragments.length,
      width: envelope.width,
      height: envelope.height,
    );
    for (final f in fragments) {
      if (f.index < session.total) session.fragments[f.index] = f;
    }
    _sessions[sessionId] = session;

    unawaited(_persist());
    notifyListeners();
  }

  /// Stream cached image fragments to [requester] via raw binary packets.
  Future<bool> serveSessionTo({
    required String sessionId,
    required Contact requester,
  }) async {
    final cached = _outgoing[sessionId];
    if (cached == null) {
      debugPrint('⚠️ [ImageProvider] No cached session for $sessionId');
      return false;
    }
    if (sendRawPacketCallback == null) {
      debugPrint('⚠️ [ImageProvider] sendRawPacketCallback not set');
      return false;
    }
    if (requester.outPathLen < 0) {
      debugPrint(
        '⚠️ [ImageProvider] ${requester.advName} has no direct path',
      );
      return false;
    }

    for (final fragment in cached.fragments) {
      try {
        await sendRawPacketCallback!(
          contactPath: requester.outPath,
          contactPathLen: requester.outPathLen,
          payload: fragment.encodeBinary(),
        );
      } catch (e, st) {
        debugPrint('❌ [ImageProvider] Serve error for $sessionId: $e\n$st');
        return false;
      }
    }
    debugPrint(
      '📷 [ImageProvider] Served ${cached.fragments.length} fragments of $sessionId',
    );
    return true;
  }

  // ── Persistence ──────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    _sessions.clear();
    _outgoing.clear();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      debugPrint('❌ [ImageProvider] Failed to clear storage: $e');
    }
  }

  void _evictExpiredOutgoing() {
    final now = DateTime.now();
    _outgoing.removeWhere(
      (_, s) => now.difference(s.cachedAt) > _outgoingTtl,
    );
  }

  Future<void> _persist() async {
    try {
      _evictExpiredOutgoing();
      final prefs = await SharedPreferences.getInstance();
      final payload = <String, dynamic>{
        'incoming': _sessions.values
            .map(
              (s) => {
                'sessionId': s.sessionId,
                'fmtId': s.format.id,
                'total': s.total,
                'width': s.width,
                'height': s.height,
                'fragments': s.fragments
                    .map(
                      (f) => f == null
                          ? null
                          : base64.encode(f.encodeBinary()),
                    )
                    .toList(),
              },
            )
            .toList(),
        'outgoing': _outgoing.values
            .map(
              (s) => {
                'sessionId': s.sessionId,
                'cachedAt': s.cachedAt.millisecondsSinceEpoch,
                'envelope': s.envelope.encode(),
                'fragments': s.fragments
                    .map((f) => base64.encode(f.encodeBinary()))
                    .toList(),
              },
            )
            .toList(),
      };
      await prefs.setString(_storageKey, jsonEncode(payload));
    } catch (e) {
      debugPrint('❌ [ImageProvider] Failed to persist: $e');
    }
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return;

      final parsed = jsonDecode(raw) as Map<String, dynamic>;

      for (final item in (parsed['incoming'] as List<dynamic>? ?? [])) {
        final map = item as Map<String, dynamic>;
        final sessionId = map['sessionId'] as String?;
        final fmtId = map['fmtId'] as int?;
        final total = map['total'] as int?;
        final width = map['width'] as int? ?? 256;
        final height = map['height'] as int? ?? 256;
        if (sessionId == null || fmtId == null || total == null || total <= 0) {
          continue;
        }
        final session = ImageSession(
          sessionId: sessionId,
          format: ImageFormat.fromId(fmtId),
          total: total,
          width: width,
          height: height,
        );
        final frags = map['fragments'] as List<dynamic>? ?? [];
        for (var i = 0; i < frags.length && i < total; i++) {
          final enc = frags[i] as String?;
          if (enc == null || enc.isEmpty) continue;
          final pkt = ImagePacket.tryParseBinary(base64.decode(enc));
          if (pkt != null && pkt.index < total) {
            session.fragments[pkt.index] = pkt;
          }
        }
        _sessions[sessionId] = session;
      }

      for (final item in (parsed['outgoing'] as List<dynamic>? ?? [])) {
        final map = item as Map<String, dynamic>;
        final sessionId = map['sessionId'] as String?;
        final cachedMs = map['cachedAt'] as int?;
        final envelopeText = map['envelope'] as String?;
        if (sessionId == null || cachedMs == null || envelopeText == null) {
          continue;
        }
        final envelope = ImageEnvelope.tryParse(envelopeText);
        if (envelope == null) continue;
        final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedMs);
        if (DateTime.now().difference(cachedAt) > _outgoingTtl) continue;

        final fragsRaw = map['fragments'] as List<dynamic>? ?? [];
        final fragments = <ImagePacket>[];
        for (final enc in fragsRaw) {
          final pkt = ImagePacket.tryParseBinary(
            base64.decode((enc ?? '') as String),
          );
          if (pkt != null) fragments.add(pkt);
        }
        if (fragments.isNotEmpty) {
          _outgoing[sessionId] = _OutgoingSession(
            sessionId: sessionId,
            fragments: fragments,
            envelope: envelope,
            cachedAt: cachedAt,
          );
        }
      }

      if (_sessions.isNotEmpty || _outgoing.isNotEmpty) {
        debugPrint(
          '📷 [ImageProvider] Restored ${_sessions.length} incoming, '
          '${_outgoing.length} outgoing sessions',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ [ImageProvider] Failed to restore: $e');
    }
  }
}

class _OutgoingSession {
  final String sessionId;
  final List<ImagePacket> fragments;
  final ImageEnvelope envelope;
  final DateTime cachedAt;

  const _OutgoingSession({
    required this.sessionId,
    required this.fragments,
    required this.envelope,
    required this.cachedAt,
  });
}

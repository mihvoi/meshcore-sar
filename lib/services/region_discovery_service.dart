import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../providers/connection_provider.dart';

/// Discovers available regions from repeater contacts via anonymous requests.
///
/// The firmware repeater responds to ANON_REQ_TYPE_REGIONS (0x01) with a
/// comma-separated list of region names that have flood allowed.
class RegionDiscoveryService {
  static const int _anonReqTypeRegions = 0x01;

  /// Discover regions from a single repeater.
  ///
  /// Sends an anonymous request to the repeater and waits for the response.
  /// Returns a list of region names (with `#` prefix).
  /// Returns empty list on timeout or error.
  static Future<List<String>> discoverFromRepeater({
    required Uint8List repeaterPublicKey,
    required ConnectionProvider connectionProvider,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final result = await connectionProvider.sendAnonRequest(
      contactPublicKey: repeaterPublicKey,
      requestData: Uint8List.fromList([_anonReqTypeRegions]),
    );
    if (result == null) return [];

    final tag = result.tag;
    final completer = Completer<List<String>>();

    void onResponse(Uint8List publicKeyPrefix, int responseTag, Uint8List data) {
      if (responseTag != tag || completer.isCompleted) return;
      completer.complete(_parseRegionResponse(data));
    }

    connectionProvider.onBinaryResponse = onResponse;

    try {
      return await completer.future.timeout(
        timeout,
        onTimeout: () => <String>[],
      );
    } catch (e) {
      debugPrint('⚠️ [RegionDiscovery] Error discovering regions: $e');
      return [];
    } finally {
      // Restore previous handler — callers should re-set if needed
      if (connectionProvider.onBinaryResponse == onResponse) {
        connectionProvider.onBinaryResponse = null;
      }
    }
  }

  /// Parse the region response payload.
  ///
  /// Format: [4B sender_timestamp][4B repeater_clock][comma-separated names]
  /// Names are returned without `#` prefix from firmware; we add it back.
  static List<String> _parseRegionResponse(Uint8List data) {
    if (data.length <= 8) return [];

    final namesStr = utf8.decode(data.sublist(8), allowMalformed: true).trim();
    if (namesStr.isEmpty || namesStr == '-none-') return [];

    return namesStr
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty && name != '*' && !name.startsWith('\$'))
        .map((name) => name.startsWith('#') ? name : '#$name')
        .toList();
  }
}

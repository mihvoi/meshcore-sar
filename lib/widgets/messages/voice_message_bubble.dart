import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/voice_provider.dart';
import '../../models/message.dart';

/// A message bubble that shows a voice recording with play/stop controls.
class VoiceMessageBubble extends StatelessWidget {
  final Message message;
  final bool isSentByMe;

  const VoiceMessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    final voiceId = message.voiceId;
    if (voiceId == null) return const SizedBox.shrink();

    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, _) {
        final session = voiceProvider.session(voiceId);
        final isPlaying = voiceProvider.isPlaying(voiceId);
        final isComplete = voiceProvider.isComplete(voiceId);

        final received = session?.receivedCount ?? 0;
        final total = session?.total ?? 0;
        final durationSec = session?.estimatedDurationSeconds ?? 0.0;
        final durationLabel = _formatDuration(durationSec);
        final modeLabel = session?.mode.label ?? '?';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play / Stop button
            InkWell(
              onTap: () async {
                if (isPlaying) {
                  await voiceProvider.stop();
                } else {
                  await voiceProvider.play(voiceId);
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSentByMe
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.stop : Icons.play_arrow,
                  size: 28,
                  color: isSentByMe
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Waveform placeholder / progress indicator
                if (isPlaying)
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.withValues(alpha: 0.3),
                    ),
                  )
                else
                  _WaveformBar(isComplete: isComplete),
                const SizedBox(height: 4),
                // Duration + mode + packet progress
                Text(
                  _buildStatusText(
                    durationLabel: durationLabel,
                    modeLabel: modeLabel,
                    received: received,
                    total: total,
                    isComplete: isComplete,
                  ),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static String _formatDuration(double seconds) {
    final s = seconds.round();
    if (s < 60) return '${s}s';
    return '${s ~/ 60}m ${s % 60}s';
  }

  static String _buildStatusText({
    required String durationLabel,
    required String modeLabel,
    required int received,
    required int total,
    required bool isComplete,
  }) {
    final progress = total > 0 ? ' ($received/$total)' : '';
    if (!isComplete && total > 0) {
      return '🎙️ $durationLabel · $modeLabel$progress';
    }
    return '🎙️ $durationLabel · $modeLabel';
  }
}

/// Simple static waveform bar using a row of rectangles.
class _WaveformBar extends StatelessWidget {
  final bool isComplete;
  const _WaveformBar({required this.isComplete});

  @override
  Widget build(BuildContext context) {
    const heights = [8.0, 14.0, 10.0, 18.0, 12.0, 16.0, 10.0, 14.0, 8.0, 12.0, 16.0, 10.0];
    final color = isComplete
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
        : Colors.grey.withValues(alpha: 0.5);
    return Row(
      children: heights
          .map((h) => Container(
                width: 3,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ))
          .toList(),
    );
  }
}

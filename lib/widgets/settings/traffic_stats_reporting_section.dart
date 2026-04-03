import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/traffic_stats_reporting_service.dart';

class TrafficStatsReportingSection extends StatelessWidget {
  final TrafficStatsReportingService service;

  const TrafficStatsReportingSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.cloud_upload_outlined),
          title: const Text('Anonymous RX stats reporting'),
          subtitle: const Text(
            'Upload RX live-traffic packet type and path mode totals to the fixed Cloudflare worker every 5 minutes.',
          ),
          value: service.isEnabled,
          onChanged: (value) async {
            await service.setEnabled(value);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload status',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _statusText(service),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ingest URL: ${TrafficStatsReportingService.ingestUri}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _openStatsDashboard,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('View public stats'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> _openStatsDashboard() async {
    final url = TrafficStatsReportingService.dashboardUri;
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static String _statusText(TrafficStatsReportingService service) {
    final buffer = StringBuffer();
    buffer.write('Pending uploads: ${service.pendingUploadCount}');
    if (service.lastSuccessAt != null) {
      buffer.write(
        '\nLast sent: ${_formatDateTime(service.lastSuccessAt!.toLocal())}',
      );
    } else {
      buffer.write('\nLast sent: Never');
    }
    if (service.lastError != null && service.lastError!.isNotEmpty) {
      buffer.write('\nLast error: ${service.lastError}');
    } else {
      buffer.write('\nLast error: None');
    }
    return buffer.toString();
  }

  static String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '${value.year}-$month-$day $hour:$minute:$second';
  }
}

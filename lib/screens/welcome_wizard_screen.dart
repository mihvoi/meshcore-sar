import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/connection_provider.dart';
import '../services/wizard_preferences.dart';
import '../widgets/connection_dialog.dart';

/// Welcome wizard screen to introduce new users to the app
class WelcomeWizardScreen extends StatefulWidget {
  final VoidCallback? onCompleted;

  const WelcomeWizardScreen({super.key, this.onCompleted});

  @override
  State<WelcomeWizardScreen> createState() => _WelcomeWizardScreenState();
}

class _WelcomeWizardScreenState extends State<WelcomeWizardScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _deviceNameController = TextEditingController();
  int _currentPage = 0;
  bool _isApplyingDeviceSetup = false;
  static const int _totalPages = 6;
  static const List<_RadioPreset> _radioPresets = [
    // Official MeshCore config presets from https://api.meshcore.nz/api/v1/config
    _RadioPreset(
      id: 'australia',
      label: 'Australia',
      summary: '915.800 MHz, BW 250 kHz, SF10, CR5',
      frequencyKhz: 915800,
      bandwidth: 8,
      spreadingFactor: 10,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'australia_narrow',
      label: 'Australia (Narrow)',
      summary: '916.575 MHz, BW 62.5 kHz, SF7, CR8',
      frequencyKhz: 916575,
      bandwidth: 6,
      spreadingFactor: 7,
      codingRate: 8,
    ),
    _RadioPreset(
      id: 'australia_sa_wa',
      label: 'Australia: SA, WA',
      summary: '923.125 MHz, BW 62.5 kHz, SF8, CR8',
      frequencyKhz: 923125,
      bandwidth: 6,
      spreadingFactor: 8,
      codingRate: 8,
    ),
    _RadioPreset(
      id: 'australia_qld',
      label: 'Australia: QLD',
      summary: '923.125 MHz, BW 62.5 kHz, SF8, CR5',
      frequencyKhz: 923125,
      bandwidth: 6,
      spreadingFactor: 8,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'eu_uk_narrow',
      label: 'EU/UK (Narrow)',
      summary: '869.618 MHz, BW 62.5 kHz, SF8, CR8',
      frequencyKhz: 869618,
      bandwidth: 6,
      spreadingFactor: 8,
      codingRate: 8,
    ),
    _RadioPreset(
      id: 'eu_uk_deprecated',
      label: 'EU/UK (Deprecated)',
      summary: '869.525 MHz, BW 250 kHz, SF11, CR5',
      frequencyKhz: 869525,
      bandwidth: 8,
      spreadingFactor: 11,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'czech_republic_narrow',
      label: 'Czech Republic (Narrow)',
      summary: '869.432 MHz, BW 62.5 kHz, SF7, CR5',
      frequencyKhz: 869432,
      bandwidth: 6,
      spreadingFactor: 7,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'eu_433_long_range',
      label: 'EU 433MHz (Long Range)',
      summary: '433.650 MHz, BW 250 kHz, SF11, CR5',
      frequencyKhz: 433650,
      bandwidth: 8,
      spreadingFactor: 11,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'new_zealand',
      label: 'New Zealand',
      summary: '917.375 MHz, BW 250 kHz, SF11, CR5',
      frequencyKhz: 917375,
      bandwidth: 8,
      spreadingFactor: 11,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'new_zealand_narrow',
      label: 'New Zealand (Narrow)',
      summary: '917.375 MHz, BW 62.5 kHz, SF7, CR5',
      frequencyKhz: 917375,
      bandwidth: 6,
      spreadingFactor: 7,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'portugal_433',
      label: 'Portugal 433',
      summary: '433.375 MHz, BW 62.5 kHz, SF9, CR6',
      frequencyKhz: 433375,
      bandwidth: 6,
      spreadingFactor: 9,
      codingRate: 6,
    ),
    _RadioPreset(
      id: 'portugal_868',
      label: 'Portugal 868',
      summary: '869.618 MHz, BW 62.5 kHz, SF7, CR6',
      frequencyKhz: 869618,
      bandwidth: 6,
      spreadingFactor: 7,
      codingRate: 6,
    ),
    _RadioPreset(
      id: 'switzerland',
      label: 'Switzerland',
      summary: '869.618 MHz, BW 62.5 kHz, SF8, CR8',
      frequencyKhz: 869618,
      bandwidth: 6,
      spreadingFactor: 8,
      codingRate: 8,
    ),
    _RadioPreset(
      id: 'usa_canada_recommended',
      label: 'USA/Canada (Recommended)',
      summary: '910.525 MHz, BW 62.5 kHz, SF7, CR5',
      frequencyKhz: 910525,
      bandwidth: 6,
      spreadingFactor: 7,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'vietnam_narrow',
      label: 'Vietnam (Narrow)',
      summary: '920.250 MHz, BW 62.5 kHz, SF8, CR5',
      frequencyKhz: 920250,
      bandwidth: 6,
      spreadingFactor: 8,
      codingRate: 5,
    ),
    _RadioPreset(
      id: 'vietnam_deprecated',
      label: 'Vietnam (Deprecated)',
      summary: '920.250 MHz, BW 250 kHz, SF11, CR5',
      frequencyKhz: 920250,
      bandwidth: 8,
      spreadingFactor: 11,
      codingRate: 5,
    ),
  ];
  _RadioPreset _selectedPreset = _radioPresets[4];

  @override
  void initState() {
    super.initState();
    final deviceInfo = context.read<ConnectionProvider>().deviceInfo;
    _deviceNameController.text =
        deviceInfo.selfName ?? deviceInfo.deviceName ?? '';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage == 1) {
      _handleDeviceSetupAction();
    } else if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeWizard();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeWizard() async {
    await WizardPreferences.setWizardCompleted(true);
    if (mounted) {
      widget.onCompleted?.call();
    }
  }

  Future<void> _openConnectionDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ConnectionDialog(),
    );
    if (!mounted) return;
    final connectionProvider = context.read<ConnectionProvider>();
    if (connectionProvider.deviceInfo.isConnected) {
      await connectionProvider.refreshDeviceInfo();
    }
    if (!mounted) return;
    final deviceInfo = connectionProvider.deviceInfo;
    final fetchedName = deviceInfo.selfName ?? deviceInfo.deviceName ?? '';
    if (fetchedName.isNotEmpty) {
      setState(() {
        _deviceNameController.text = fetchedName;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _handleDeviceSetupAction() async {
    final l10n = AppLocalizations.of(context)!;
    final connectionProvider = context.read<ConnectionProvider>();
    final deviceInfo = connectionProvider.deviceInfo;
    if (!deviceInfo.isConnected) {
      await _openConnectionDialog();
      return;
    }

    final trimmedName = _deviceNameController.text.trim();
    if (trimmedName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a device name before continuing.')),
      );
      return;
    }

    setState(() {
      _isApplyingDeviceSetup = true;
    });

    try {
      await connectionProvider.setAdvertName(trimmedName);
      await connectionProvider.setRadioParams(
        frequency: _selectedPreset.frequencyKhz,
        bandwidth: _selectedPreset.bandwidth,
        spreadingFactor: _selectedPreset.spreadingFactor,
        codingRate: _selectedPreset.codingRate,
      );
      await connectionProvider.refreshDeviceInfo();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved $trimmedName with ${_selectedPreset.label}.'),
          backgroundColor: Colors.green,
        ),
      );
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToSave(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingDeviceSetup = false;
        });
      }
    }
  }

  void _skipDeviceSetupStep() {
    if (_isApplyingDeviceSetup) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.wizardBack),
                    )
                  else
                    const SizedBox(width: 80),
                  if (_currentPage < _totalPages - 1)
                    TextButton(
                      onPressed: _completeWizard,
                      child: Text(l10n.wizardSkip),
                    )
                  else
                    const SizedBox(width: 80),
                ],
              ),
            ),

            // Page view with wizard content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomePage(context, l10n, colorScheme),
                  _buildConnectDevicePage(context, l10n, colorScheme),
                  _buildConnectingPage(context, l10n, colorScheme),
                  _buildChannelPage(context, l10n, colorScheme),
                  _buildContactsPage(context, l10n, colorScheme),
                  _buildMapPage(context, l10n, colorScheme),
                ],
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 12.0 : 8.0,
                    height: _currentPage == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isApplyingDeviceSetup ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == 1
                        ? _deviceSetupButtonLabel(context)
                        : _currentPage < _totalPages - 1
                        ? l10n.wizardNext
                        : l10n.wizardGetStarted,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return _buildPage(
      icon: Icons.waving_hand,
      iconColor: Colors.orange,
      title: 'Welcome to MeshCore SAR',
      description:
          'This app combines MeshCore messaging, SAR field updates, mapping, and device tools in one place.',
      features: [
        _FeatureItem(
          icon: Icons.chat_bubble_outline,
          text:
              'Send direct, room, and channel messages from the main Messages tab.',
        ),
        _FeatureItem(
          icon: Icons.emergency_share,
          text:
              'Share SAR markers, map drawings, voice clips, and images over the mesh.',
        ),
        _FeatureItem(
          icon: Icons.settings_input_antenna,
          text:
              'Connect over BLE or TCP, then manage the companion radio from inside the app.',
        ),
      ],
      colorScheme: colorScheme,
    );
  }

  Widget _buildConnectingPage(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return _buildPage(
      icon: Icons.forum_rounded,
      iconColor: Colors.blue,
      title: 'Messaging and Field Reports',
      description:
          'Messages are more than plain text here. The app already supports several operational payloads and transfer workflows.',
      features: [
        _FeatureItem(
          icon: Icons.chat,
          text:
              'Send direct messages, room posts, and channel traffic from one composer.',
        ),
        _FeatureItem(
          icon: Icons.campaign,
          text:
              'Create SAR updates and reusable SAR templates for common field reports.',
        ),
        _FeatureItem(
          icon: Icons.mic,
          text:
              'Transfer voice sessions and images, with progress and airtime estimates in the UI.',
        ),
      ],
      colorScheme: colorScheme,
    );
  }

  Widget _buildConnectDevicePage(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final connectionProvider = context.watch<ConnectionProvider>();
    final deviceInfo = connectionProvider.deviceInfo;
    final isConnected = deviceInfo.isConnected;
    final connectedName = deviceInfo.selfName ?? deviceInfo.deviceName;

    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: constraints.maxHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPageHeader(
                  context: context,
                  colorScheme: colorScheme,
                  icon: Icons.bluetooth_connected,
                  iconColor: Colors.green,
                  title: 'Connect device',
                  description:
                      'Connect your MeshCore radio, choose a name, and apply a radio preset before continuing.',
                  badge: 'Setup',
                ),
                const SizedBox(height: 16),
                _buildContentCard(
                  colorScheme: colorScheme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isConnected
                                ? Icons.check_circle
                                : Icons.bluetooth_searching,
                            color: isConnected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isConnected
                                  ? 'Connected to ${connectedName ?? "device"}'
                                  : 'No device connected yet',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: _openConnectionDialog,
                            child: Text(isConnected ? 'Change' : l10n.connect),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _skipDeviceSetupStep,
                          child: const Text('Skip for now'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildContentCard(
                  colorScheme: colorScheme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _deviceNameController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Device name',
                          border: OutlineInputBorder(),
                          helperText:
                              'This name is advertised to other MeshCore users.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<_RadioPreset>(
                        initialValue: _selectedPreset,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Config region',
                          border: OutlineInputBorder(),
                          helperText:
                              'Uses the full official MeshCore preset list. Default is EU/UK (Narrow).',
                        ),
                        items: _radioPresets
                            .map(
                              (preset) => DropdownMenuItem<_RadioPreset>(
                                value: preset,
                                child: Text(
                                  preset.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (preset) {
                          if (preset == null) return;
                          setState(() {
                            _selectedPreset = preset;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildContentCard(
                  colorScheme: colorScheme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPreset.label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedPreset.summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      ...[
                        _FeatureItem(
                          icon: Icons.rule,
                          text:
                              'Make sure the selected preset matches your local radio regulations.',
                        ),
                        _FeatureItem(
                          icon: Icons.settings_input_antenna,
                          text:
                              'The list matches the official MeshCore config tool preset feed.',
                        ),
                        _FeatureItem(
                          icon: Icons.public,
                          text:
                              'EU/UK (Narrow) stays selected by default for onboarding.',
                        ),
                      ].map(
                        (feature) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: _buildFeatureRow(
                            context,
                            colorScheme,
                            feature,
                            iconSize: 20,
                            gap: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _deviceSetupButtonLabel(BuildContext context) {
    final isConnected = context
        .watch<ConnectionProvider>()
        .deviceInfo
        .isConnected;
    if (_isApplyingDeviceSetup) {
      return 'Saving...';
    }
    return isConnected ? 'Save and continue' : 'Connect device';
  }

  Widget _buildChannelPage(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return _buildPage(
      icon: Icons.groups_rounded,
      iconColor: Colors.purple,
      title: 'Contacts, Rooms, and Repeaters',
      description:
          'The Contacts tab organizes the network you discover and the routes you learn over time.',
      features: [
        _FeatureItem(
          icon: Icons.person_add_alt_1,
          text:
              'Review team members, repeaters, rooms, channels, and pending adverts in one list.',
        ),
        _FeatureItem(
          icon: Icons.route,
          text:
              'Use smart ping, room login, learned paths, and route reset tools when connectivity gets messy.',
        ),
        _FeatureItem(
          icon: Icons.hub,
          text:
              'Create channels and manage network destinations without leaving the app.',
        ),
      ],
      colorScheme: colorScheme,
    );
  }

  Widget _buildContactsPage(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return _buildPage(
      icon: Icons.map_rounded,
      iconColor: Colors.teal,
      title: 'Map, Trails, and Shared Geometry',
      description:
          'The app map is tied directly into messaging, tracking, and SAR overlays instead of being a separate viewer.',
      features: [
        _FeatureItem(
          icon: Icons.location_on,
          text:
              'Track your own position, teammate locations, and movement trails on the map.',
        ),
        _FeatureItem(
          icon: Icons.draw,
          text:
              'Open drawings from messages, preview them inline, and remove them from the map when needed.',
        ),
        _FeatureItem(
          icon: Icons.router,
          text:
              'Use repeater map views and shared overlays to understand network reach in the field.',
        ),
      ],
      colorScheme: colorScheme,
    );
  }

  Widget _buildMapPage(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return _buildPage(
      icon: Icons.tune_rounded,
      iconColor: Colors.red,
      title: 'Tools Beyond Messaging',
      description:
          'There is more here than the four main tabs. The app also includes configuration, diagnostics, and optional sensor workflows.',
      features: [
        _FeatureItem(
          icon: Icons.settings,
          text:
              'Open device config to change radio settings, telemetry, TX power, and companion details.',
        ),
        _FeatureItem(
          icon: Icons.sensors,
          text:
              'Enable the Sensors tab when you want watched sensor dashboards and quick refresh actions.',
        ),
        _FeatureItem(
          icon: Icons.analytics_outlined,
          text:
              'Use packet logs, spectrum scan, and developer diagnostics when troubleshooting the mesh.',
        ),
      ],
      colorScheme: colorScheme,
    );
  }

  Widget _buildPage({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    List<_FeatureItem>? features,
    required ColorScheme colorScheme,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: constraints.maxHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageHeader(
                  context: context,
                  colorScheme: colorScheme,
                  icon: icon,
                  iconColor: iconColor,
                  title: title,
                  description: description,
                  badge: 'Overview',
                ),
                if (features != null && features.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  _buildContentCard(
                    colorScheme: colorScheme,
                    child: Column(
                      children: features
                          .map(
                            (feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: _buildFeatureRow(
                                context,
                                colorScheme,
                                feature,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader({
    required BuildContext context,
    required ColorScheme colorScheme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String badge,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            badge,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 56, color: iconColor),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.72),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContentCard({
    required ColorScheme colorScheme,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    ColorScheme colorScheme,
    _FeatureItem feature, {
    double iconSize = 22,
    double gap = 14,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(feature.icon, color: colorScheme.primary, size: iconSize),
        SizedBox(width: gap),
        Expanded(
          child: Text(
            feature.text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String text;

  _FeatureItem({required this.icon, required this.text});
}

class _RadioPreset {
  final String id;
  final String label;
  final String summary;
  final int frequencyKhz;
  final int bandwidth;
  final int spreadingFactor;
  final int codingRate;

  const _RadioPreset({
    required this.id,
    required this.label,
    required this.summary,
    required this.frequencyKhz,
    required this.bandwidth,
    required this.spreadingFactor,
    required this.codingRate,
  });
}

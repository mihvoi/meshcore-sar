import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/contact.dart';
import '../providers/connection_provider.dart';
import '../providers/contacts_provider.dart';
import '../services/mesh_map_nodes_service.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final Set<String> _resolvingAdvertKeys = <String>{};
  bool _isResolvingAll = false;
  late final Future<List<MeshMapNode>> _cachedNodesFuture;

  @override
  void initState() {
    super.initState();
    _cachedNodesFuture = MeshMapNodesService.loadCachedNodes(
      cacheTtl: MeshMapNodesService.traceCacheTtl,
    );
  }

  Future<void> _resolveAdvert(PendingAdvert advert) async {
    final keyHex = advert.publicKeyHex;
    if (_resolvingAdvertKeys.contains(keyHex)) return;

    setState(() {
      _resolvingAdvertKeys.add(keyHex);
    });

    try {
      await context.read<ConnectionProvider>().getContact(advert.publicKey);
    } finally {
      if (mounted) {
        setState(() {
          _resolvingAdvertKeys.remove(keyHex);
        });
      }
    }
  }

  Future<void> _resolveAll(List<PendingAdvert> adverts) async {
    if (_isResolvingAll || adverts.isEmpty) return;

    setState(() {
      _isResolvingAll = true;
    });

    try {
      for (final advert in adverts) {
        if (!mounted) break;
        await _resolveAdvert(advert);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingAll = false;
        });
      }
    }
  }

  String _formatRelativeTime(BuildContext context, DateTime when) {
    final l10n = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    return l10n.daysAgo(diff.inDays);
  }

  String _displayNameForAdvert(
    PendingAdvert advert,
    ContactsProvider contactsProvider,
    List<MeshMapNode> cachedNodes,
  ) {
    Contact? existingMatch;
    for (final contact in contactsProvider.contacts) {
      if (contact.publicKeyHex == advert.publicKeyHex) {
        existingMatch = contact;
        break;
      }
    }
    if (existingMatch != null && existingMatch.displayName.trim().isNotEmpty) {
      return existingMatch.displayName;
    }

    MeshMapNode? cachedMatch;
    for (final node in cachedNodes) {
      if (node.publicKey == advert.publicKeyHex.toLowerCase()) {
        cachedMatch = node;
        break;
      }
    }
    if (cachedMatch != null && cachedMatch.name.trim().isNotEmpty) {
      return cachedMatch.name;
    }

    return advert.shortDisplayKey;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Discovery')),
      body: FutureBuilder<List<MeshMapNode>>(
        future: _cachedNodesFuture,
        builder: (context, nodesSnapshot) =>
            Consumer2<ContactsProvider, ConnectionProvider>(
              builder: (context, contactsProvider, connectionProvider, child) {
                final pendingAdverts = contactsProvider.pendingAdverts;
                final isConnected = connectionProvider.deviceInfo.isConnected;
                final cachedNodes = nodesSnapshot.data ?? const <MeshMapNode>[];

                if (pendingAdverts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search_outlined,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No pending discoveries',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Unknown adverts will appear here until you choose to resolve them.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.person_search),
                        title: Text(
                          'Pending discoveries (${pendingAdverts.length})',
                        ),
                        subtitle: const Text(
                          'Resolve entries manually so they do not auto-populate contacts.',
                        ),
                        trailing: FilledButton.icon(
                          onPressed: isConnected && !_isResolvingAll
                              ? () => _resolveAll(pendingAdverts)
                              : null,
                          icon: _isResolvingAll
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download_for_offline_outlined),
                          label: const Text('Resolve all'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...pendingAdverts.map((advert) {
                      final isResolving = _resolvingAdvertKeys.contains(
                        advert.publicKeyHex,
                      );
                      final displayName = _displayNameForAdvert(
                        advert,
                        contactsProvider,
                        cachedNodes,
                      );
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.campaign_outlined),
                          ),
                          title: Text(
                            displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${l10n.publicKey}: ${advert.shortDisplayKey}\n'
                            '${l10n.lastSeen}: ${_formatRelativeTime(context, advert.receivedAt)}',
                          ),
                          trailing: isResolving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.person_add_alt_1),
                                  tooltip: 'Resolve contact',
                                  onPressed: isConnected
                                      ? () => _resolveAdvert(advert)
                                      : null,
                                ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
      ),
    );
  }
}

part of 'pg_feed_sync.dart';

class _FeedSyncScreen extends StatelessWidget {
  const _FeedSyncScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.syncSettingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _MockTile(
              icon: Icons.cloud_sync_outlined,
              title: context.l10n.autoSync,
              subtitle: context.l10n.autoSyncSubtitle,
            ),
            const SizedBox(height: 10),
            _MockTile(
              icon: Icons.sync_rounded,
              title: context.l10n.syncNow,
              subtitle: context.l10n.syncNowMockSubtitle,
            ),
            const SizedBox(height: 10),
            _MockTile(
              icon: Icons.history_rounded,
              title: context.l10n.lastSyncedAt,
              subtitle: context.l10n.syncMockLastSyncedValue,
            ),
            const SizedBox(height: 10),
            _MockTile(
              icon: Icons.storage_rounded,
              title: context.l10n.syncConflictResolution,
              subtitle: context.l10n.syncConflictResolutionSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _MockTile extends StatelessWidget {
  const _MockTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: context.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

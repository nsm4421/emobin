part of 'pg_feed_entry.dart';

class _FeedSyncStatusChip extends StatelessWidget {
  const _FeedSyncStatusChip({required this.status});

  final FeedSyncStatus status;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, foregroundColor, label) = switch (status) {
      FeedSyncStatus.synced => (
        context.colorScheme.primary.withAlpha(20),
        context.colorScheme.primary,
        'Synced',
      ),
      FeedSyncStatus.pendingUpload => (
        context.colorScheme.tertiary.withAlpha(18),
        context.colorScheme.tertiary,
        'Pending',
      ),
      FeedSyncStatus.conflict => (
        context.colorScheme.errorContainer,
        context.colorScheme.onErrorContainer,
        'Conflict',
      ),
      FeedSyncStatus.localOnly => (
        context.colorScheme.surfaceContainerHighest,
        context.colorScheme.onSurfaceVariant,
        'Local',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

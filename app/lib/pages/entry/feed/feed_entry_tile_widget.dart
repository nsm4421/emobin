part of 'feed_entry_page.dart';

class _FeedEntryTileWidget extends StatelessWidget {
  const _FeedEntryTileWidget({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final note = entry.note?.trim();
    final username = entry.profile?.username ?? entry.createdBy;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.colorScheme.primary.withAlpha(24),
                child: Text(
                  _emotionShortLabel(entry.emotion),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.emotion,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      username,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _FeedSyncStatusChipWidget(status: entry.syncStatus),
            ],
          ),
          if (note != null && note.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              note,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 16,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(entry.createdAt),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedSyncStatusChipWidget extends StatelessWidget {
  const _FeedSyncStatusChipWidget({required this.status});

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

String _emotionShortLabel(String emotion) {
  final trimmed = emotion.trim();
  if (trimmed.isEmpty) return '-';
  final firstRune = trimmed.runes.first;
  return String.fromCharCode(firstRune).toUpperCase();
}

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final date =
      '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)}';
  final time = '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  return '$date $time';
}

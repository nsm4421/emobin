part of 'feed_entry_page.dart';

class _FeedEntryTileWidget extends StatelessWidget {
  const _FeedEntryTileWidget({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final note = entry.note.trim();
    final emotion = entry.emotion?.trim();
    final emotionLabel = emotion == null || emotion.isEmpty
        ? 'Unknown'
        : emotion;

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
                  _emotionShortLabel(emotionLabel),
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
                      emotionLabel,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _FeedSyncStatusChipWidget(status: entry.syncStatus),
            ],
          ),
          if (note.isNotEmpty) ...[
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

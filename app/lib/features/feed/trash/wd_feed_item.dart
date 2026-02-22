part of 'pg_feed_trash.dart';

class _TrashItem extends StatelessWidget {
  const _TrashItem({
    required this.entry,
    required this.isBusy,
    required this.onRestore,
    required this.onHardDelete,
  });

  final FeedEntry entry;
  final bool isBusy;
  final VoidCallback onRestore;
  final VoidCallback onHardDelete;

  String _entryTitle(BuildContext context, FeedEntry entry) {
    final title = entry.title?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }

    final hashtag = entry.hashtags
        .map((tag) => tag.trim())
        .firstWhere((tag) => tag.isNotEmpty, orElse: () => '');
    if (hashtag.isNotEmpty) {
      return '#$hashtag';
    }

    return context.l10n.untitledFeed;
  }

  String _entryPreview(BuildContext context, FeedEntry entry) {
    final note = entry.note.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (note.isEmpty) {
      return entry.isDraft
          ? context.l10n.draftFeedPreview
          : context.l10n.noContentYet;
    }
    return note;
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _entryTitle(context, entry),
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              _entryPreview(context, entry),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.deletedAtWithValue(
                _formatDateTime(entry.deletedAt!),
              ),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: isBusy ? null : onRestore,
                  icon: isBusy
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.restore_rounded, size: 18),
                  label: Text(context.l10n.restore),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: isBusy ? null : onHardDelete,
                  icon: const Icon(Icons.delete_forever_outlined, size: 18),
                  label: Text(context.l10n.deleteForever),
                  style: FilledButton.styleFrom(
                    foregroundColor: context.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

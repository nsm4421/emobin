part of 'pg_feed_entry.dart';

class _FeedEntryTile extends StatelessWidget {
  const _FeedEntryTile({required this.entry});

  final ff.FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final note = entry.note.trim();
    final emotion = entry.emotion?.trim();
    final hasEmotion = emotion != null && emotion.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasEmotion)
                    Row(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          size: 16,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            emotion,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      note,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                        size: 14,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.createdAt.ago,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<_FeedEntryAction>(
              icon: Icon(
                Icons.more_vert,
                size: 16,
                color: context.colorScheme.onSurfaceVariant.withAlpha(145),
              ),
              iconSize: 16,
              splashRadius: 14,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              tooltip: 'Entry actions',
              onSelected: (action) => _onSelectedAction(context, action),
              itemBuilder: (context) => [
                PopupMenuItem<_FeedEntryAction>(
                  value: _FeedEntryAction.edit,
                  child: Row(
                    children: const [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem<_FeedEntryAction>(
                  value: _FeedEntryAction.delete,
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSelectedAction(
    BuildContext context,
    _FeedEntryAction action,
  ) async {
    switch (action) {
      case _FeedEntryAction.edit:
        await _editEntry(context);
      case _FeedEntryAction.delete:
        await _deleteEntry(context);
    }
  }

  Future<void> _editEntry(BuildContext context) async {
    await context.router.push(EditFeedRoute(feedId: entry.id));
    if (!context.mounted) return;
    _refresh(context);
  }

  Future<void> _openDetail(BuildContext context) async {
    await context.router.push(FeedDetailRoute(feedId: entry.id));
    if (!context.mounted) return;
    _refresh(context);
  }

  Future<void> _deleteEntry(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Feed'),
          content: const Text('Do you want to delete this feed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !context.mounted) return;

    final result = await GetIt.instance<FeedUseCase>().softDeleteLocalEntry(
      entry.id,
    );
    if (!context.mounted) return;

    result.match((failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
    }, (_) => _refresh(context));
  }

  void _refresh(BuildContext context) {
    context.read<DisplayFeedListBloc>().add(
      const DisplayFeedListEvent.refreshRequested(showLoading: false),
    );
  }
}

enum _FeedEntryAction { edit, delete }

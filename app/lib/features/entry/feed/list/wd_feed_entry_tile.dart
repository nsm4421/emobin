part of '../pg_display_feed_entry.dart';

class _FeedEntryTile extends StatelessWidget {
  const _FeedEntryTile({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final title = entry.title?.trim();
    final note = entry.note.trim();
    final hashtagSummary = _buildHashtagSummary(entry.hashtags);

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
                  if (title != null && title.isNotEmpty) ...[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (hashtagSummary != null)
                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 16,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            hashtagSummary,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: context.colorScheme.primary,
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
                      Flexible(
                        child: Text(
                          entry.createdAt.agoWithLocale(localeCode),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
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
              tooltip: context.l10n.entryActions,
              onSelected: (action) => _onSelectedAction(context, action),
              itemBuilder: (context) => [
                PopupMenuItem<_FeedEntryAction>(
                  value: _FeedEntryAction.edit,
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(context.l10n.edit),
                    ],
                  ),
                ),
                PopupMenuItem<_FeedEntryAction>(
                  value: _FeedEntryAction.delete,
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 18),
                      const SizedBox(width: 8),
                      Text(context.l10n.delete),
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
          title: Text(context.l10n.deleteFeedTitle),
          content: Text(context.l10n.deleteFeedMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !context.mounted) return;

    final result = await context.read<DisplayFeedListBloc>().softDeleteEntry(
      entry.id,
    );
    if (!context.mounted) return;

    result.match((failure) {
      ToastHelper.error(failure.message);
    }, (_) => _refresh(context));
  }

  void _refresh(BuildContext context) {
    context.read<DisplayFeedListBloc>().add(
      const DisplayFeedListEvent.refreshRequested(showLoading: false),
    );
    context.read<DisplayFeedCalendarBloc>().add(
      const DisplayFeedCalendarEvent.refreshRequested(showLoading: false),
    );
  }
}

enum _FeedEntryAction { edit, delete }

String? _buildHashtagSummary(List<String> hashtags) {
  final normalized = hashtags
      .map((tag) => tag.trim().replaceFirst(RegExp(r'^#+'), ''))
      .where((tag) => tag.isNotEmpty)
      .toList(growable: false);
  if (normalized.isEmpty) return null;

  const previewCount = 2;
  final preview = normalized.take(previewCount).map((tag) => '#$tag').join(' ');
  final remaining = normalized.length - previewCount;
  if (remaining <= 0) {
    return preview;
  }

  return '$preview +$remaining';
}

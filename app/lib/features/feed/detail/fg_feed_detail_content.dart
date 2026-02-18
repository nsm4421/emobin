part of 'pg_feed_detail.dart';

class _FeedDetailContent extends StatelessWidget {
  const _FeedDetailContent({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final emotion = entry.emotion?.trim();
    final hasEmotion = emotion != null && emotion.isNotEmpty;
    final emotionTag = hasEmotion ? '#${_normalizeHashtag(emotion)}' : null;
    final note = entry.note.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
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
                  Expanded(
                    child: emotionTag == null
                        ? const SizedBox.shrink()
                        : Text(
                            emotionTag,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  PopupMenuButton<_FeedDetailAction>(
                    tooltip: 'Feed actions',
                    onSelected: (action) async {
                      switch (action) {
                        case _FeedDetailAction.edit:
                          await _editEntry(context);
                        case _FeedDetailAction.delete:
                          await _deleteEntry(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<_FeedDetailAction>(
                        value: _FeedDetailAction.edit,
                        child: Text('Edit Feed'),
                      ),
                      PopupMenuItem<_FeedDetailAction>(
                        value: _FeedDetailAction.delete,
                        child: Text(
                          'Delete Feed',
                          style: TextStyle(color: context.colorScheme.error),
                        ),
                      ),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                note.isEmpty ? 'No note yet.' : note,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              title: Text(
                'Details',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                _FeedDetailMetaRow(
                  label: 'Intensity',
                  value: entry.intensity.toString(),
                ),
                _FeedDetailMetaRow(
                  label: 'Created At',
                  value: _formatDateTime(entry.createdAt),
                ),
                _FeedDetailMetaRow(
                  label: 'Draft',
                  value: entry.isDraft ? 'Yes' : 'No',
                ),
                _FeedDetailMetaRow(
                  label: 'Sync Status',
                  value: entry.syncStatus.name,
                ),
                _FeedDetailMetaRow(
                  label: 'Updated At',
                  value: entry.updatedAt == null
                      ? '-'
                      : _formatDateTime(entry.updatedAt!),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editEntry(BuildContext context) async {
    await context.router.push(EditFeedRoute(feedId: entry.id));
    if (!context.mounted) return;
    context.read<DetailFeedCubit>().load();
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

    result.match(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        if (context.router.canPop()) {
          context.router.pop(true);
          return;
        }
        context.read<DetailFeedCubit>().load();
      },
    );
  }
}

enum _FeedDetailAction { edit, delete }

String _normalizeHashtag(String raw) {
  return raw.trim().replaceAll(RegExp(r'\s+'), '_');
}

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final date =
      '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)}';
  final time = '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  return '$date $time';
}

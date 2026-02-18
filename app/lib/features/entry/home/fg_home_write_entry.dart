part of 'pg_home_entry.dart';

class _HomeWriteEntry extends StatelessWidget {
  const _HomeWriteEntry();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to Write?',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start a new entry or continue your draft.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await context.router.push(CreateFeedRoute());
                if (!context.mounted) return;
                context.read<DisplayFeedListBloc>().add(
                  const DisplayFeedListEvent.refreshRequested(
                    showLoading: false,
                  ),
                );
              },
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Write Today\'s Entry'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _onContinueDraftPressed(context),
              icon: const Icon(Icons.restore_rounded),
              label: const Text('Continue Draft'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onContinueDraftPressed(BuildContext context) async {
    final fetchDrafts = GetIt.instance<FeedUseCase>().fetchLocalEntries;
    final result = await fetchDrafts();
    if (!context.mounted) return;

    result.match(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (entries) {
        final drafts = entries
            .where((entry) => entry.isDraft && entry.deletedAt == null)
            .toList(growable: false);

        showDialog<void>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Saved Drafts'),
              content: SizedBox(
                width: double.maxFinite,
                child: drafts.isEmpty
                    ? const Text('No saved drafts.')
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 360),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: drafts.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final draft = drafts[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.description_outlined,
                                color: context.colorScheme.primary,
                              ),
                              title: Text(_draftTitle(draft)),
                              subtitle: Text(
                                '${_formatDraftDateTime(draft.createdAt)}\n${_draftPreview(draft.note)}',
                              ),
                              isThreeLine: true,
                              onTap: () async {
                                Navigator.of(dialogContext).pop();
                                await context.router.push(
                                  EditFeedRoute(feedId: draft.id),
                                );
                                if (!context.mounted) return;
                                context.read<DisplayFeedListBloc>().add(
                                  const DisplayFeedListEvent.refreshRequested(
                                    showLoading: false,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

String _draftTitle(FeedEntry entry) {
  final emotion = entry.emotion?.trim();
  if (emotion == null || emotion.isEmpty) {
    return 'Untitled Draft';
  }
  return emotion;
}

String _draftPreview(String note) {
  final normalized = note.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (normalized.isEmpty) {
    return 'No content yet';
  }
  if (normalized.length <= 42) {
    return normalized;
  }
  return '${normalized.substring(0, 42)}...';
}

String _formatDraftDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final date =
      '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)}';
  final time = '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  return '$date $time';
}

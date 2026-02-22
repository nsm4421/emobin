part of 'pg_feed_trash.dart';

class _FeedTrashScreen extends StatelessWidget {
  const _FeedTrashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.trashMenu)),
      body: SafeArea(
        child: BlocBuilder<FeedTrashCubit, FeedTrashState>(
          builder: (context, state) {
            switch (state.status) {
              case FeedTrashStatus.initial:
              case FeedTrashStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case FeedTrashStatus.failure:
                final message =
                    state.failure?.message ?? context.l10n.failedLoadTrashList;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () =>
                              context.read<FeedTrashCubit>().load(),
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              case FeedTrashStatus.success:
                if (state.entries.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.noDeletedFeeds,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<FeedTrashCubit>().load(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    itemCount: state.entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = state.entries[index];
                      return _TrashItem(
                        entry: entry,
                        isBusy: state.busyEntryIds.contains(entry.id),
                        onRestore: () => _onRestorePressed(context, entry),
                        onHardDelete: () =>
                            _onHardDeletePressed(context, entry),
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> _onRestorePressed(BuildContext context, FeedEntry entry) async {
    final result = await context.read<FeedTrashCubit>().restoreEntry(entry);
    if (!context.mounted) return;

    result.match(
      (failure) => ToastHelper.error(failure.message),
      (_) => ToastHelper.success(context.l10n.feedRestored),
    );
  }

  Future<void> _onHardDeletePressed(
    BuildContext context,
    FeedEntry entry,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.permanentDeleteTitle),
          content: Text(context.l10n.permanentDeleteMessage),
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

    final result = await context.read<FeedTrashCubit>().hardDeleteEntry(
      entry.id,
    );
    if (!context.mounted) return;

    result.match(
      (failure) => ToastHelper.error(failure.message),
      (_) => ToastHelper.success(context.l10n.feedPermanentlyDeleted),
    );
  }
}

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
            context.l10n.readyToWriteTitle,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.readyToWriteSubtitle,
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
                context.read<HomeRecordStatusCubit>().refresh();
              },
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(context.l10n.writeTodaysEntry),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _onContinueDraftPressed(context),
              icon: const Icon(Icons.restore_rounded),
              label: Text(context.l10n.continueDraft),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onContinueDraftPressed(BuildContext context) async {
    final result = await context
        .read<HomeRecordStatusCubit>()
        .fetchDraftEntries();
    if (!context.mounted) return;

    result.match(
      (failure) {
        ToastHelper.error(failure.message);
      },
      (drafts) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (sheetContext) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.savedDrafts,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (drafts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(context.l10n.noSavedDrafts),
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 360),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: drafts.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final localeCode = Localizations.localeOf(
                              context,
                            ).languageCode;
                            final draft = drafts[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.description_outlined,
                                color: context.colorScheme.primary,
                              ),
                              title: Text(_draftTitle(context, draft)),
                              subtitle: Text(
                                '${draft.createdAt.agoWithLocale(localeCode)} · ${_formatDraftDateTime(draft.createdAt)}\n${_draftPreview(context, draft.note)}',
                              ),
                              isThreeLine: true,
                              onTap: () async {
                                Navigator.of(sheetContext).pop();
                                await context.router.push(
                                  EditFeedRoute(feedId: draft.id),
                                );
                                if (!context.mounted) return;
                                context.read<HomeRecordStatusCubit>().refresh();
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: Text(context.l10n.close),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

String _draftTitle(BuildContext context, FeedEntry entry) {
  final title = entry.title?.trim();
  if (title != null && title.isNotEmpty) {
    return title;
  }

  final firstHashtag = entry.hashtags
      .map((tag) => tag.trim())
      .firstWhere((tag) => tag.isNotEmpty, orElse: () => '');
  if (firstHashtag.isEmpty) {
    return context.l10n.untitledDraft;
  }
  return firstHashtag;
}

String _draftPreview(BuildContext context, String note) {
  final normalized = note.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (normalized.isEmpty) {
    return context.l10n.noContentYet;
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

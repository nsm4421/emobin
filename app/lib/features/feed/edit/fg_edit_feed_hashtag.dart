part of 'pg_edit_feed.dart';

class _EditFeedHashtag extends StatelessWidget {
  const _EditFeedHashtag();

  @override
  Widget build(BuildContext context) {
    final hashtags = context.select<FeedHashtagPresetCubit, List<String>>(
      (cubit) => cubit.state.hashtags,
    );
    final hashtagPresetCubit = context.read<FeedHashtagPresetCubit>();

    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        return FeedEditorHashtag(
          selectedHashtags: state.data.hashtags,
          presetHashtags: hashtags,
          maxSelectable: 3,
          onOpenHashtagEditor: () async {
            await context.router.push(
              EditHashtagRoute(cubit: hashtagPresetCubit),
            );
            if (!context.mounted) return;

            final selectedHashtags = context
                .read<EditFeedCubit>()
                .state
                .data
                .hashtags;
            final presetSet = hashtagPresetCubit.state.hashtags
                .map(_normalizeHashtag)
                .toSet();
            final filtered = selectedHashtags
                .map(_normalizeHashtag)
                .where((tag) => presetSet.contains(tag))
                .take(3)
                .toList(growable: false);
            if (filtered.length != selectedHashtags.length) {
              context.read<EditFeedCubit>().setHashtags(filtered);
            }
          },
          onChanged: (next) {
            context.read<EditFeedCubit>().setHashtags(next);
          },
          onMaxSelectionReached: () {
            ToastHelper.error(context.l10n.hashtagSelectionLimitToast(3));
          },
        );
      },
    );
  }
}

String _normalizeHashtag(String raw) {
  return raw.trim().replaceFirst(RegExp(r'^#+'), '');
}

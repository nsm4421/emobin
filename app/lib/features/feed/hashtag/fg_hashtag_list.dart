part of 'pg_edit_hashtag.dart';

class _HashtagList extends StatelessWidget {
  const _HashtagList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedHashtagPresetCubit, FeedHashtagPresetState>(
      builder: (context, state) {
        final hashtags = state.hashtags;

        if (hashtags.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: Text(
              'No saved hashtags yet.',
              style: context.textTheme.bodyMedium,
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: hashtags.length,
            itemBuilder: (context, index) {
              final hashtag = hashtags[index];
              return ListTile(
                dense: true,
                title: Text(hashtag),
                trailing: IconButton(
                  onPressed: state.isLoading
                      ? null
                      : () => context
                            .read<FeedHashtagPresetCubit>()
                            .removeHashtag(hashtag),
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  tooltip: 'Remove',
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          ),
        );
      },
    );
  }
}

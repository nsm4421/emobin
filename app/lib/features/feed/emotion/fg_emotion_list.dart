part of 'pg_edit_emotion.dart';

class _EmotionList extends StatelessWidget {
  const _EmotionList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedEmotionPresetCubit, FeedEmotionPresetState>(
      builder: (context, state) {
        final emotions = state.emotions;

        if (emotions.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: Text(
              'No saved emotions yet.',
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
            itemCount: emotions.length,
            itemBuilder: (context, index) {
              final emotion = emotions[index];
              return ListTile(
                dense: true,
                title: Text(emotion),
                trailing: IconButton(
                  onPressed: state.isLoading
                      ? null
                      : () => context
                            .read<FeedEmotionPresetCubit>()
                            .removeEmotion(emotion),
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

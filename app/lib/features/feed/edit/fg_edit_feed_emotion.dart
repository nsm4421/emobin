part of 'pg_edit_feed.dart';

class _EditFeedEmotion extends StatelessWidget {
  const _EditFeedEmotion();

  @override
  Widget build(BuildContext context) {
    final emotions = context.select<FeedEmotionPresetCubit, List<String>>(
      (cubit) => cubit.state.emotions,
    );
    final emotionPresetCubit = context.read<FeedEmotionPresetCubit>();

    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        return FeedEditorEmotion(
          currentEmotion: state.data.emotion,
          currentIntensity: state.data.intensity,
          emotions: emotions,
          onOpenEmotionEditor: () async {
            await context.router.push(
              EditEmotionRoute(cubit: emotionPresetCubit),
            );
            if (!context.mounted) return;

            final selectedEmotion = context
                .read<EditFeedCubit>()
                .state
                .data
                .emotion;
            final emotionPresets = emotionPresetCubit.state.emotions;
            if (selectedEmotion != null &&
                !emotionPresets.contains(selectedEmotion)) {
              context.read<EditFeedCubit>().clearEmotion();
            }
          },
          onSelectEmotion: (emotion, intensity) {
            context.read<EditFeedCubit>().setEmotion(
              emotion: emotion,
              intensity: intensity,
            );
          },
          onClearEmotion: () => context.read<EditFeedCubit>().clearEmotion(),
        );
      },
    );
  }
}

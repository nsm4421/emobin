part of 'pg_create_feed.dart';

class _CreateFeedEmotion extends StatelessWidget {
  const _CreateFeedEmotion();

  @override
  Widget build(BuildContext context) {
    final emotions = context.select<FeedEmotionPresetCubit, List<String>>(
      (cubit) => cubit.state.emotions,
    );
    final emotionPresetCubit = context.read<FeedEmotionPresetCubit>();

    return BlocBuilder<CreateFeedCubit, CreateFeedState>(
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
                .read<CreateFeedCubit>()
                .state
                .data
                .emotion;
            final emotionPresets = emotionPresetCubit.state.emotions;
            if (selectedEmotion != null &&
                !emotionPresets.contains(selectedEmotion)) {
              context.read<CreateFeedCubit>().clearEmotion();
            }
          },
          onSelectEmotion: (emotion, intensity) {
            context.read<CreateFeedCubit>().setEmotion(
              emotion: emotion,
              intensity: intensity,
            );
          },
          onClearEmotion: () => context.read<CreateFeedCubit>().clearEmotion(),
        );
      },
    );
  }
}

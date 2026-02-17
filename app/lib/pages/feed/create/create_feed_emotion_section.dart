part of 'create_feed_page.dart';

class _CreateFeedEmotionSection extends StatelessWidget {
  const _CreateFeedEmotionSection();

  @override
  Widget build(BuildContext context) {
    final currentEmotion = context.select<CreateFeedCubit, String?>(
      (cubit) => cubit.state.data.emotion,
    );
    final currentIntensity = context.select<CreateFeedCubit, int>(
      (cubit) => cubit.state.data.intensity,
    );
    final emotions = context.select<FeedEmotionPresetCubit, List<String>>(
      (cubit) => cubit.state.emotions,
    );
    final emotionPresetCubit = context.read<FeedEmotionPresetCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Emotion', style: context.textTheme.titleMedium),
            ),
            IconButton(
              onPressed: () async {
                // emotion 수정페이지로 라우팅
                await context.router.push(
                  EditEmotionRoute(cubit: emotionPresetCubit),
                );
                if (!context.mounted) return;

                // 선택한 emotion이 삭제된 경우, 선택 해제
                final currentEmotion = context.select<CreateFeedCubit, String?>(
                  (cubit) => cubit.state.data.emotion,
                );
                final emotionPresets = context
                    .select<FeedEmotionPresetCubit, List<String>>(
                      (cubit) => cubit.state.emotions,
                    );
                if (currentEmotion != null &&
                    !emotionPresets.contains(currentEmotion)) {
                  context.read<CreateFeedCubit>().clearEmotion();
                }
              },
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit emotions',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: emotions
              .map(
                (emotion) => ChoiceChip(
                  label: Text(
                    currentEmotion == emotion
                        ? '$emotion (+$currentIntensity)'
                        : emotion,
                  ),
                  selected: currentEmotion == emotion,
                  onSelected: (_) {
                    context.read<CreateFeedCubit>().setEmotion(
                      emotion: emotion,
                      intensity: currentIntensity + 1,
                    );
                  },
                ),
              )
              .toList(growable: false),
        ),
        if (currentEmotion != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Selected: $currentEmotion ($currentIntensity/5)',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<CreateFeedCubit>().clearEmotion();
                },
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Clear selection',
              ),
            ],
          ),
        ],
      ],
    );
  }
}

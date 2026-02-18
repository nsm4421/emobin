part of 'pg_edit_emotion.dart';

class _EmotionInput extends StatefulWidget {
  const _EmotionInput();

  @override
  State<_EmotionInput> createState() => _EmotionInputFragmentState();
}

class _EmotionInputFragmentState extends State<_EmotionInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void _handleAdd() {
    final emotion = _controller.text.trim();
    if (emotion.isEmpty) {
      return;
    }
    context.read<FeedEmotionPresetCubit>().addEmotion(emotion);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedEmotionPresetCubit, FeedEmotionPresetState>(
      builder: (context, state) {
        final tappable = !state.isLoading;
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => tappable ? _handleAdd() : null,
                decoration: const InputDecoration(hintText: 'Type an emotion'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: tappable ? _handleAdd : null,
              iconSize: 30,
              tooltip: 'Add emotion',
              icon: tappable
                  ? const Icon(Icons.add_circle_rounded)
                  : const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
            ),
          ],
        );
      },
    );
  }
}

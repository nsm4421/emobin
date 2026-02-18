part of 'pg_edit_hashtag.dart';

class _HashtagInput extends StatefulWidget {
  const _HashtagInput();

  @override
  State<_HashtagInput> createState() => _HashtagInputState();
}

class _HashtagInputState extends State<_HashtagInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void _handleAdd() {
    final hashtag = _normalizeHashtag(_controller.text.trim());
    if (hashtag.isEmpty) {
      return;
    }
    context.read<FeedHashtagPresetCubit>().addHashtag('#$hashtag');
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedHashtagPresetCubit, FeedHashtagPresetState>(
      builder: (context, state) {
        final tappable = !state.isLoading;
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => tappable ? _handleAdd() : null,
                decoration: const InputDecoration(hintText: 'Type a hashtag'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: tappable ? _handleAdd : null,
              iconSize: 30,
              tooltip: 'Add hashtag',
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

  String _normalizeHashtag(String raw) {
    return raw.replaceFirst(RegExp(r'^#+'), '');
  }
}

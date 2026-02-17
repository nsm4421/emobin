part of 'create_feed_page.dart';

class _CreateFeedNoteSection extends StatefulWidget {
  const _CreateFeedNoteSection();

  @override
  State<_CreateFeedNoteSection> createState() => _CreateFeedNoteSectionState();
}

class _CreateFeedNoteSectionState extends State<_CreateFeedNoteSection> {
  late final TextEditingController _controller;

  static const int _maxNoteLength = 5000;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note', style: context.textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          minLines: 6,
          maxLines: 10,
          maxLength: _maxNoteLength,
          onChanged: (value) {
            context.read<CreateFeedCubit>().updateNote(value);
          },
          decoration: const InputDecoration(
            hintText:
                'e.g.) I could not express myself well in the meeting. I feel calmer now.',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

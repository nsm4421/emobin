import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:flutter/material.dart';

class FeedEditorNote extends StatefulWidget {
  const FeedEditorNote({
    super.key,
    required this.note,
    required this.onChanged,
  });

  final String note;
  final ValueChanged<String> onChanged;

  @override
  State<FeedEditorNote> createState() => _FeedEditorNoteState();
}

class _FeedEditorNoteState extends State<FeedEditorNote> {
  late final TextEditingController _controller;

  static const int _maxNoteLength = 5000;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note);
  }

  @override
  void didUpdateWidget(covariant FeedEditorNote oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text == widget.note) return;
    _controller.value = TextEditingValue(
      text: widget.note,
      selection: TextSelection.collapsed(offset: widget.note.length),
    );
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
        Text(context.l10n.note, style: context.textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          minLines: 6,
          maxLines: 10,
          maxLength: _maxNoteLength,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: context.l10n.noteHint,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

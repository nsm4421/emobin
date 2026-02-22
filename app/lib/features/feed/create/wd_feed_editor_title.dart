import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';

class FeedEditorTitle extends StatefulWidget {
  const FeedEditorTitle({
    super.key,
    required this.title,
    required this.onChanged,
  });

  final String? title;
  final ValueChanged<String> onChanged;

  @override
  State<FeedEditorTitle> createState() => _FeedEditorTitleState();
}

class _FeedEditorTitleState extends State<FeedEditorTitle> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title ?? '');
  }

  @override
  void didUpdateWidget(covariant FeedEditorTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextTitle = widget.title ?? '';
    if (_controller.text == nextTitle) return;
    _controller.value = TextEditingValue(
      text: nextTitle,
      selection: TextSelection.collapsed(offset: nextTitle.length),
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
        Text(context.l10n.entryTitle, style: context.textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          maxLines: 1,
          maxLength: feedTitleMaxLength,
          textInputAction: TextInputAction.next,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: context.l10n.entryTitleHint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

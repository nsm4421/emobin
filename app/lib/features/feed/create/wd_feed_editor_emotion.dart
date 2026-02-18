import 'package:core/core.dart';
import 'package:flutter/material.dart';

class FeedEditorEmotion extends StatelessWidget {
  const FeedEditorEmotion({
    super.key,
    required this.currentEmotion,
    required this.currentIntensity,
    required this.emotions,
    required this.onOpenEmotionEditor,
    required this.onSelectEmotion,
    required this.onClearEmotion,
  });

  final String? currentEmotion;
  final int currentIntensity;
  final List<String> emotions;
  final VoidCallback onOpenEmotionEditor;
  final void Function(String emotion, int intensity) onSelectEmotion;
  final VoidCallback onClearEmotion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Emotion', style: context.textTheme.titleMedium),
            ),
            IconButton(
              onPressed: onOpenEmotionEditor,
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
                    onSelectEmotion(emotion, currentIntensity + 1);
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
                  'Selected: $currentEmotion ($currentIntensity)',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              IconButton(
                onPressed: onClearEmotion,
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

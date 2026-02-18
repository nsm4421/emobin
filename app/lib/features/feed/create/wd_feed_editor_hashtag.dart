import 'package:core/core.dart';
import 'package:flutter/material.dart';

class FeedEditorHashtag extends StatelessWidget {
  const FeedEditorHashtag({
    super.key,
    required this.selectedHashtags,
    required this.presetHashtags,
    required this.onOpenHashtagEditor,
    required this.onChanged,
    this.maxSelectable = 3,
    this.onMaxSelectionReached,
  });

  final List<String> selectedHashtags;
  final List<String> presetHashtags;
  final VoidCallback onOpenHashtagEditor;
  final ValueChanged<List<String>> onChanged;
  final int maxSelectable;
  final VoidCallback? onMaxSelectionReached;

  @override
  Widget build(BuildContext context) {
    final presets = _normalizeHashtags(presetHashtags);
    final selected = _normalizeHashtags(selectedHashtags);
    final selectedSet = selected.toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Hashtags', style: context.textTheme.titleMedium),
            ),
            IconButton(
              onPressed: onOpenHashtagEditor,
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: context.colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Edit hashtags',
              visualDensity: VisualDensity.compact,
              splashRadius: 18,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (presets.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: Text(
              'No hashtag presets yet.',
              style: context.textTheme.bodyMedium,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets
                .map(
                  (hashtag) => ChoiceChip(
                    label: Text('#$hashtag'),
                    selected: selectedSet.contains(hashtag),
                    onSelected: (isSelected) {
                      final next = [...selected];
                      if (isSelected) {
                        if (!next.contains(hashtag)) {
                          if (next.length >= maxSelectable) {
                            onMaxSelectionReached?.call();
                            return;
                          }
                          next.add(hashtag);
                        }
                      } else {
                        next.remove(hashtag);
                      }
                      onChanged(next);
                    },
                  ),
                )
                .toList(growable: false),
          ),
        const SizedBox(height: 8),
        Text(
          'Select up to $maxSelectable hashtags.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        if (selected.isNotEmpty) const SizedBox(height: 4),
      ],
    );
  }

  List<String> _normalizeHashtags(List<String> hashtags) {
    return hashtags
        .map((tag) => tag.trim().replaceFirst(RegExp(r'^#+'), ''))
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}

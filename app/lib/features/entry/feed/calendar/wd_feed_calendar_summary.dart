part of '../pg_display_feed_entry.dart';

class _FeedCalendarSummary extends StatelessWidget {
  const _FeedCalendarSummary({
    required this.focusedMonth,
    required this.entryCount,
  });

  final DateTime focusedMonth;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = entryCount == 0
        ? l10n.noEntriesInMonth(_monthLabel(focusedMonth))
        : l10n.entriesInMonth(entryCount, _monthLabel(focusedMonth));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.edit_calendar_rounded,
            size: 18,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

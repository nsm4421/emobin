part of '../pg_display_feed_entry.dart';

class _FeedCalendarMonthGrid extends StatelessWidget {
  const _FeedCalendarMonthGrid({
    required this.focusedMonth,
    required this.dayCounts,
    required this.selectedDate,
    required this.onTapDate,
  });

  final DateTime focusedMonth;
  final Map<int, int> dayCounts;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onTapDate;

  @override
  Widget build(BuildContext context) {
    final weekdayLabels = [
      context.l10n.weekdaySun,
      context.l10n.weekdayMon,
      context.l10n.weekdayTue,
      context.l10n.weekdayWed,
      context.l10n.weekdayThu,
      context.l10n.weekdayFri,
      context.l10n.weekdaySat,
    ];
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final leadingBlankCount = firstDay.weekday % 7;
    final dayCount = DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final rawCellCount = leadingBlankCount + dayCount;
    final trailingBlankCount = (7 - rawCellCount % 7) % 7;
    final totalCellCount = rawCellCount + trailingBlankCount;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: totalCellCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final day = index - leadingBlankCount + 1;
              if (day < 1 || day > dayCount) {
                return const SizedBox.shrink();
              }

              final entryCount = dayCounts[day] ?? 0;
              final hasEntry = entryCount > 0;
              final now = DateTime.now();
              final isToday =
                  now.year == focusedMonth.year &&
                  now.month == focusedMonth.month &&
                  now.day == day;
              final cellDate = DateTime(
                focusedMonth.year,
                focusedMonth.month,
                day,
              );
              final isSelected =
                  selectedDate != null &&
                  DateUtils.isSameDay(selectedDate, cellDate);

              return _FeedCalendarDayCell(
                day: day,
                entryCount: entryCount,
                hasEntry: hasEntry,
                isToday: isToday,
                isSelected: isSelected,
                onTap: hasEntry ? () => onTapDate(cellDate) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

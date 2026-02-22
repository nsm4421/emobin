part of '../pg_display_feed_entry.dart';

class _FeedCalendarDayCell extends StatelessWidget {
  const _FeedCalendarDayCell({
    required this.day,
    required this.entryCount,
    required this.hasEntry,
    required this.isToday,
    required this.isSelected,
    this.onTap,
  });

  final int day;
  final int entryCount;
  final bool hasEntry;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final badgeText = entryCount > 9 ? '9+' : '$entryCount';
    final backgroundColor = switch ((isSelected, hasEntry)) {
      (true, _) => context.colorScheme.primary,
      (false, true) => context.colorScheme.primaryContainer.withAlpha(140),
      (false, false) => context.colorScheme.surfaceContainerHighest.withAlpha(
        90,
      ),
    };
    final borderColor = switch ((isSelected, isToday, hasEntry)) {
      (true, _, _) => context.colorScheme.primary,
      (false, true, _) => context.colorScheme.primary,
      (false, false, true) => context.colorScheme.primaryContainer,
      (false, false, false) => context.colorScheme.outlineVariant,
    };
    final dayTextColor = isSelected
        ? context.colorScheme.onPrimary
        : hasEntry
        ? context.colorScheme.onPrimaryContainer
        : context.colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: isSelected || isToday ? 1.5 : 1,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 6,
                left: 6,
                child: Text(
                  '$day',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: hasEntry ? FontWeight.w700 : FontWeight.w500,
                    color: dayTextColor,
                  ),
                ),
              ),
              if (hasEntry)
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badgeText,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

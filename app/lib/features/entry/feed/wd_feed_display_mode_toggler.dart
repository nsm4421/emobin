part of 'pg_display_feed_entry.dart';

class _FeedDisplayModeToggler extends StatelessWidget {
  const _FeedDisplayModeToggler({required this.state});

  final DisplayFeedModeState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 96,
        height: 36,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withAlpha(72),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outlineVariant.withAlpha(18),
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                alignment: state.when(
                  list: () => Alignment.centerLeft,
                  calendar: (_) => Alignment.centerRight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer.withAlpha(
                          210,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _FeedDisplayModeToggleButton(
                      tooltip: context.l10n.listMode,
                      selected: state.when(
                        list: () => true,
                        calendar: (_) => false,
                      ),
                      icon: Icons.list_alt_rounded,
                      onTap: context.read<DisplayFeedModeCubit>().toList,
                    ),
                  ),
                  Expanded(
                    child: _FeedDisplayModeToggleButton(
                      tooltip: context.l10n.calendarMode,
                      selected: state.when(
                        list: () => false,
                        calendar: (_) => true,
                      ),
                      icon: Icons.calendar_month_rounded,
                      onTap: context.read<DisplayFeedModeCubit>().toCalendar,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedDisplayModeToggleButton extends StatelessWidget {
  const _FeedDisplayModeToggleButton({
    required this.tooltip,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected
        ? context.colorScheme.onPrimaryContainer
        : context.colorScheme.onSurfaceVariant.withAlpha(120);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onTap,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Icon(
                selected ? icon : _outlined(icon),
                key: ValueKey<bool>(selected),
                size: selected ? 19 : 17,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _outlined(IconData icon) {
    return switch (icon) {
      Icons.list_alt_rounded => Icons.list_alt_outlined,
      Icons.calendar_month_rounded => Icons.calendar_month_outlined,
      _ => icon,
    };
  }
}

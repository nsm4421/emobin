part of 'pg_home_entry.dart';

class _HomeFeedStatus extends StatelessWidget {
  const _HomeFeedStatus();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedListBloc, DisplayFeedListState>(
      builder: (context, state) {
        final metrics = _buildFeedStatusMetrics(state.entries);
        final isFailed = state.status == DisplayFeedListStatus.failure;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Today\'s Journal Status',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (state.status == DisplayFeedListStatus.loading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (isFailed)
                    IconButton(
                      onPressed: () {
                        context.read<DisplayFeedListBloc>().add(
                          const DisplayFeedListEvent.refreshRequested(
                            showLoading: false,
                          ),
                        );
                      },
                      tooltip: 'Retry',
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isFailed
                    ? (state.failure?.message ?? 'Failed to load feed status.')
                    : metrics.message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _HomeStatusMetric(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Streak',
                      value: '${metrics.streakDays} days',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeStatusMetric(
                      icon: Icons.today_rounded,
                      label: 'Today',
                      value: metrics.todayDone ? 'Done' : 'Pending',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeStatusMetric(
                      icon: Icons.edit_calendar_rounded,
                      label: 'This Week',
                      value: '${metrics.thisWeekCount} / 7',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef _HomeFeedStatusMetrics = ({
  bool todayDone,
  int streakDays,
  int thisWeekCount,
  String message,
});

_HomeFeedStatusMetrics _buildFeedStatusMetrics(List<FeedEntry> entries) {
  final validEntries = entries
      .where((entry) => !entry.isDraft && entry.deletedAt == null)
      .toList(growable: false);
  final today = DateUtils.dateOnly(DateTime.now());
  final recordedDays = validEntries
      .map((entry) => DateUtils.dateOnly(entry.createdAt.toLocal()))
      .toSet();

  final todayDone = recordedDays.contains(today);
  final streakDays = _calculateStreak(recordedDays, today);
  final thisWeekCount = _countThisWeek(recordedDays, today);
  final message = todayDone
      ? 'Today is recorded. Keep your momentum going.'
      : 'No entry yet. Capture today before it slips away.';

  return (
    todayDone: todayDone,
    streakDays: streakDays,
    thisWeekCount: thisWeekCount,
    message: message,
  );
}

int _calculateStreak(Set<DateTime> recordedDays, DateTime today) {
  var streak = 0;
  var cursor = today;
  while (recordedDays.contains(cursor)) {
    streak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

int _countThisWeek(Set<DateTime> recordedDays, DateTime today) {
  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  var count = 0;
  for (var i = 0; i < 7; i++) {
    final day = startOfWeek.add(Duration(days: i));
    if (recordedDays.contains(day)) {
      count += 1;
    }
  }
  return count;
}

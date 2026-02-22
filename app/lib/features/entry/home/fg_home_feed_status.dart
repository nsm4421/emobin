part of 'pg_home_entry.dart';

class _HomeFeedStatus extends StatelessWidget {
  const _HomeFeedStatus();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeRecordStatusCubit, HomeRecordStatusState>(
      builder: (context, state) {
        final status = state.recordStatus;
        final statusMessage = status.todayDone
            ? context.l10n.todayRecordedMessage
            : context.l10n.noEntryYetMessage;

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
                      context.l10n.todayJournalStatus,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (state.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                statusMessage,
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
                      label: context.l10n.streak,
                      value: context.l10n.daysCount(status.streakDays),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeStatusMetric(
                      icon: Icons.today_rounded,
                      label: context.l10n.todayLabel,
                      value: status.todayDone
                          ? context.l10n.done
                          : context.l10n.pending,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeStatusMetric(
                      icon: Icons.edit_calendar_rounded,
                      label: context.l10n.thisWeek,
                      value: '${status.thisWeekCount} / 7',
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

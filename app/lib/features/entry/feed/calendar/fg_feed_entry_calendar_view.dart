part of '../pg_display_feed_entry.dart';

class _FeedEntryCalendarView extends StatefulWidget {
  const _FeedEntryCalendarView();

  @override
  State<_FeedEntryCalendarView> createState() => _FeedEntryCalendarViewState();
}

class _FeedEntryCalendarViewState extends State<_FeedEntryCalendarView> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    context.read<DisplayFeedCalendarBloc>().add(
      const DisplayFeedCalendarEvent.started(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedCalendarBloc, DisplayFeedCalendarState>(
      builder: (context, state) {
        final entries = state.entries;
        final focusedMonth = state.focusedMonth;
        final isLoading = state.status == DisplayFeedCalendarStatus.loading;
        final hasFailure = state.status == DisplayFeedCalendarStatus.failure;
        final failureMessage =
            state.failure?.message ?? context.l10n.failedLoadFeedCalendar;

        if (isLoading && entries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hasFailure && entries.isEmpty) {
          return _FeedEntryFailure(
            message: failureMessage,
            onRetry: () {
              _requestCalendarRefresh(context, showLoading: true);
            },
          );
        }

        final dayCounts = _toDayCounts(entries);
        final visibleEntries = _filterEntriesBySelectedDate(
          entries: entries,
          selectedDate: _selectedDate,
        );

        return RefreshIndicator(
          onRefresh: () => _requestCalendarRefresh(context, showLoading: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              if (isLoading) ...[
                const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 12),
              ],
              if (hasFailure) ...[
                _FeedEntryErrorBanner(
                  message: failureMessage,
                  onRetry: () {
                    _requestCalendarRefresh(context, showLoading: true);
                  },
                ),
                const SizedBox(height: 12),
              ],
              _FeedCalendarMonthTabs(
                focusedMonth: focusedMonth,
                onTapFocusedMonth: () => _selectMonth(focusedMonth),
              ),
              const SizedBox(height: 12),
              _FeedCalendarMonthGrid(
                focusedMonth: focusedMonth,
                dayCounts: dayCounts,
                selectedDate: _selectedDate,
                onTapDate: _onTapDate,
              ),
              const SizedBox(height: 12),
              _FeedCalendarSummary(
                focusedMonth: focusedMonth,
                entryCount: entries.length,
              ),
              const SizedBox(height: 12),
              if (_selectedDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDateLabel(_selectedDate!),
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _selectedDate = null),
                        child: Text(context.l10n.cancel),
                      ),
                    ],
                  ),
                ),
              if (visibleEntries.isEmpty)
                _FeedEntryEmpty()
              else
                ...visibleEntries.map((entry) => _FeedEntryTile(entry: entry)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectMonth(DateTime focusedMonth) async {
    final selectedMonth = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return _FeedCalendarMonthInputDialog(initialMonth: focusedMonth);
      },
    );
    if (selectedMonth == null || !mounted) return;

    setState(() {
      _selectedDate = null;
    });

    context.read<DisplayFeedCalendarBloc>().add(
      DisplayFeedCalendarEvent.monthChanged(
        focusedMonth: DateTime(selectedMonth.year, selectedMonth.month),
      ),
    );
  }

  void _onTapDate(DateTime date) {
    setState(() {
      if (_selectedDate != null && DateUtils.isSameDay(_selectedDate, date)) {
        _selectedDate = null;
        return;
      }
      _selectedDate = date;
    });
  }
}

String _monthLabel(DateTime month) {
  final normalized = DateTime(month.year, month.month);
  return '${normalized.year}.${normalized.month}';
}

Map<int, int> _toDayCounts(List<FeedEntry> entries) {
  final dayCounts = <int, int>{};
  for (final entry in entries) {
    final day = entry.createdAt.toLocal().day;
    dayCounts.update(day, (value) => value + 1, ifAbsent: () => 1);
  }
  return dayCounts;
}

List<FeedEntry> _filterEntriesBySelectedDate({
  required List<FeedEntry> entries,
  required DateTime? selectedDate,
}) {
  if (selectedDate == null) {
    return entries;
  }

  final selectedDay = DateUtils.dateOnly(selectedDate);
  return entries
      .where((entry) {
        final createdDay = DateUtils.dateOnly(entry.createdAt.toLocal());
        return createdDay == selectedDay;
      })
      .toList(growable: false);
}

String _selectedDateLabel(DateTime date) {
  final local = date.toLocal();

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  return '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)}';
}

Future<void> _requestCalendarRefresh(
  BuildContext context, {
  required bool showLoading,
}) async {
  final bloc = context.read<DisplayFeedCalendarBloc>();
  bloc.add(DisplayFeedCalendarEvent.refreshRequested(showLoading: showLoading));
  await bloc.stream.firstWhere(
    (state) => state.status != DisplayFeedCalendarStatus.loading,
  );
}

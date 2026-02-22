part of '../pg_display_feed_entry.dart';

class _FeedEntryListView extends StatefulWidget {
  const _FeedEntryListView();

  @override
  State<_FeedEntryListView> createState() => _FeedEntryListViewFragmentState();
}

class _FeedEntryListViewFragmentState extends State<_FeedEntryListView> {
  static const double _loadMoreThreshold = 240;

  @override
  void initState() {
    super.initState();
    context.read<DisplayFeedListBloc>().add(DisplayFeedListEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedListBloc, DisplayFeedListState>(
      builder: (context, state) {
        final entries = state.entries;
        final isLoading = state.status == DisplayFeedListStatus.loading;
        final hasFailure = state.status == DisplayFeedListStatus.failure;
        final failureMessage =
            state.failure?.message ?? context.l10n.failedLoadFeedList;

        if (isLoading && entries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hasFailure && entries.isEmpty) {
          return _FeedEntryFailure(
            message: failureMessage,
            onRetry: () {
              _requestFeedRefresh(context, showLoading: true);
            },
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis != Axis.vertical) return false;
            final shouldLoadMore =
                notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - _loadMoreThreshold;
            if (!shouldLoadMore) return false;
            _requestLoadMore();
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => _requestFeedRefresh(context, showLoading: true),
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
                      _requestFeedRefresh(context, showLoading: true);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                if (entries.isEmpty) const _FeedEntryEmpty(),
                ..._buildDateSectionedEntries(context, entries),
                if (state.isLoadingMore) ...[
                  const SizedBox(height: 12),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _requestLoadMore() {
    final bloc = context.read<DisplayFeedListBloc>();
    final state = bloc.state;
    if (state.isLoadingMore || !state.hasMore) return;
    bloc.add(const DisplayFeedListEvent.loadMoreRequested());
  }

  List<Widget> _buildDateSectionedEntries(
    BuildContext context,
    List<FeedEntry> entries,
  ) {
    final widgets = <Widget>[];
    DateTime? previousDate;

    for (final entry in entries) {
      final currentDate = DateUtils.dateOnly(entry.createdAt.toLocal());
      final isNewSection =
          previousDate == null ||
          !DateUtils.isSameDay(previousDate, currentDate);

      if (isNewSection) {
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: 8));
        }
        widgets.add(_FeedEntryDateSectionHeader(date: currentDate));
        widgets.add(const SizedBox(height: 8));
      }

      widgets.add(_FeedEntryTile(entry: entry));
      previousDate = currentDate;
    }

    return widgets;
  }
}

class _FeedEntryDateSectionHeader extends StatelessWidget {
  const _FeedEntryDateSectionHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateLabel = MaterialLocalizations.of(context).formatMediumDate(date);

    return Row(
      children: [
        Text(
          dateLabel,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            height: 1,
            color: context.colorScheme.outlineVariant.withAlpha(155),
          ),
        ),
      ],
    );
  }
}

Future<void> _requestFeedRefresh(
  BuildContext context, {
  required bool showLoading,
}) async {
  final bloc = context.read<DisplayFeedListBloc>();
  bloc.add(DisplayFeedListEvent.refreshRequested(showLoading: showLoading));
  await bloc.stream.firstWhere(
    (state) => state.status != DisplayFeedListStatus.loading,
  );
}

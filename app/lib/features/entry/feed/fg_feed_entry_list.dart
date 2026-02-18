part of 'pg_feed_entry.dart';

class _FeedEntryList extends StatefulWidget {
  const _FeedEntryList();

  @override
  State<_FeedEntryList> createState() => _FeedEntryListFragmentState();
}

class _FeedEntryListFragmentState extends State<_FeedEntryList> {
  static const double _loadMoreThreshold = 160;

  late final ScrollController _scrollController;
  bool _postFrameLoadCheckScheduled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _requestLoadMoreIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedListBloc, DisplayFeedListState>(
      builder: (context, state) {
        _schedulePostFrameLoadCheck(state);

        final entries = state.entries;
        final isLoading = state.status == DisplayFeedListStatus.loading;
        final hasFailure = state.status == DisplayFeedListStatus.failure;
        final failureMessage =
            state.failure?.message ?? 'Failed to load the feed list.';

        if (isLoading && entries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hasFailure && entries.isEmpty) {
          return _FeedEntryFailure(
            message: failureMessage,
            onRetry: () {
              _requestRefresh(context, showLoading: true);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => _requestRefresh(context, showLoading: true),
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              if (isLoading) ...[
                const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 12),
              ],
              if (hasFailure) ...[
                _FeedEntryErrorBanner(
                  message: failureMessage,
                  onRetry: () {
                    _requestRefresh(context, showLoading: true);
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (entries.isEmpty) const _FeedEntryEmpty(),
              ...entries.map((entry) => _FeedEntryTile(entry: entry)),
              if (state.isLoadingMore) ...[
                const SizedBox(height: 12),
                const Center(child: CircularProgressIndicator()),
              ] else if (state.hasMore) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    '스크롤해서 더 보기',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _requestLoadMoreIfNeeded() {
    if (!_scrollController.hasClients) {
      return;
    }
    final bloc = context.read<DisplayFeedListBloc>();
    final state = bloc.state;
    if (!_canLoadMore(state)) {
      return;
    }
    final reachedThreshold =
        _scrollController.position.extentAfter <= _loadMoreThreshold;
    if (!reachedThreshold) {
      return;
    }
    bloc.add(const DisplayFeedListEvent.loadMoreRequested());
  }

  void _schedulePostFrameLoadCheck(DisplayFeedListState state) {
    if (_postFrameLoadCheckScheduled || !_canLoadMore(state)) {
      return;
    }
    _postFrameLoadCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFrameLoadCheckScheduled = false;
      if (!mounted) {
        return;
      }
      _requestLoadMoreIfNeeded();
    });
  }

  bool _canLoadMore(DisplayFeedListState state) {
    return state.hasMore &&
        !state.isLoadingMore &&
        state.status != DisplayFeedListStatus.loading;
  }

  Future<void> _requestRefresh(
    BuildContext context, {
    required bool showLoading,
  }) async {
    final bloc = context.read<DisplayFeedListBloc>();
    bloc.add(DisplayFeedListEvent.refreshRequested(showLoading: showLoading));
    await bloc.stream.firstWhere(
      (state) => state.status != DisplayFeedListStatus.loading,
    );
  }
}

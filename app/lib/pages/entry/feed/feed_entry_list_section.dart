part of 'feed_entry_page.dart';

class _FeedEntryListSection extends StatelessWidget {
  const _FeedEntryListSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedListBloc, DisplayFeedListState>(
      builder: (context, state) {
        final entries = state.entries;
        final isLoading = state.status == DisplayFeedListStatus.loading;
        final hasFailure = state.status == DisplayFeedListStatus.failure;
        final failureMessage =
            state.failure?.message ?? 'Failed to load the feed list.';

        if (isLoading && entries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hasFailure && entries.isEmpty) {
          return _FeedEntryFailureSection(
            message: failureMessage,
            onRetry: () {
              _requestRefresh(context, showLoading: true);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => _requestRefresh(context, showLoading: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              if (isLoading) ...[
                const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 12),
              ],
              if (hasFailure) ...[
                _FeedEntryErrorBannerWidget(
                  message: failureMessage,
                  onRetry: () {
                    _requestRefresh(context, showLoading: true);
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (entries.isEmpty) const _FeedEntryEmptySection(),
              ...entries.map((entry) => _FeedEntryTileWidget(entry: entry)),
            ],
          ),
        );
      },
    );
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

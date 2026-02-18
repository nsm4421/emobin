part of 'pg_feed_detail.dart';

class _FeedDetailScreen extends StatelessWidget {
  const _FeedDetailScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailFeedCubit, DetailFeedState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              notFound: () => _FeedDetailStatus(
                title: 'Feed not found',
                message: 'The requested feed does not exist.',
                actionLabel: 'Back',
                onPressed: () {
                  if (context.router.canPop()) {
                    context.router.pop();
                  }
                },
              ),
              failure: (failure) => _FeedDetailStatus(
                title: 'Failed to load feed',
                message: failure.message,
                actionLabel: 'Retry',
                onPressed: () {
                  context.read<DetailFeedCubit>().load();
                },
              ),
              loaded: (entry) => _FeedDetailContent(entry: entry),
            ),
          ),
        );
      },
    );
  }
}

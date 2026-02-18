part of 'pg_feed_detail.dart';

class _FeedDetailScreen extends StatefulWidget {
  const _FeedDetailScreen();

  @override
  State<_FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<_FeedDetailScreen> {
  static const double _edgeSwipeWidth = 28;
  static const double _popDragDistance = 72;
  static const double _popVelocity = 900;

  bool _isEdgeDragging = false;
  double _dragOffsetX = 0;

  void _handleHorizontalDragStart(DragStartDetails details) {
    _isEdgeDragging = details.globalPosition.dx <= _edgeSwipeWidth;
    _dragOffsetX = 0;
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isEdgeDragging) return;
    _dragOffsetX += details.primaryDelta ?? 0;
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (!_isEdgeDragging) return;
    _isEdgeDragging = false;

    final velocityX = details.primaryVelocity ?? 0;
    final shouldPop =
        _dragOffsetX >= _popDragDistance || velocityX >= _popVelocity;
    _dragOffsetX = 0;

    if (shouldPop && context.router.canPop()) {
      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailFeedCubit, DetailFeedState>(
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _handleHorizontalDragStart,
            onHorizontalDragUpdate: _handleHorizontalDragUpdate,
            onHorizontalDragEnd: _handleHorizontalDragEnd,
            child: SafeArea(
              top: false,
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
          ),
        );
      },
    );
  }
}

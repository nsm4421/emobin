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
        final loadedEntry = state.maybeWhen(
          loaded: (entry) => entry,
          orElse: () => null,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(
              loadedEntry == null
                  ? context.l10n.feedTitle
                  : _resolveTitle(loadedEntry),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              if (loadedEntry != null)
                PopupMenuButton<_FeedDetailAction>(
                  tooltip: context.l10n.feedActions,
                  onSelected: (action) =>
                      _onSelectedAction(loadedEntry, action),
                  itemBuilder: (context) => [
                    PopupMenuItem<_FeedDetailAction>(
                      value: _FeedDetailAction.edit,
                      child: Text(context.l10n.editFeedAction),
                    ),
                    PopupMenuItem<_FeedDetailAction>(
                      value: _FeedDetailAction.delete,
                      child: Text(
                        context.l10n.deleteFeedAction,
                        style: TextStyle(color: context.colorScheme.error),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _handleHorizontalDragStart,
            onHorizontalDragUpdate: _handleHorizontalDragUpdate,
            onHorizontalDragEnd: _handleHorizontalDragEnd,
            child: SafeArea(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                notFound: () => _FeedDetailStatus(
                  title: context.l10n.feedNotFoundTitle,
                  message: context.l10n.feedNotFoundMessage,
                  actionLabel: context.l10n.back,
                  onPressed: () {
                    if (context.router.canPop()) {
                      context.router.pop();
                    }
                  },
                ),
                failure: (failure) => _FeedDetailStatus(
                  title: context.l10n.failedLoadFeedTitle,
                  message: failure.message,
                  actionLabel: context.l10n.retry,
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

  String _resolveTitle(FeedEntry entry) {
    final title = entry.title?.trim();
    if (title == null || title.isEmpty) {
      return context.l10n.feedTitle;
    }
    return title;
  }

  Future<void> _onSelectedAction(
    FeedEntry entry,
    _FeedDetailAction action,
  ) async {
    switch (action) {
      case _FeedDetailAction.edit:
        await _editEntry(entry.id);
        break;
      case _FeedDetailAction.delete:
        await _deleteEntry();
        break;
    }
  }

  Future<void> _editEntry(String feedId) async {
    await context.router.push(EditFeedRoute(feedId: feedId));
    if (!mounted) return;
    context.read<DetailFeedCubit>().load();
  }

  Future<void> _deleteEntry() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.deleteFeedTitle),
          content: Text(context.l10n.deleteFeedMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !mounted) return;

    final result = await context
        .read<DetailFeedCubit>()
        .softDeleteCurrentEntry();
    if (!mounted) return;

    result.match(
      (failure) {
        ToastHelper.error(failure.message);
      },
      (_) {
        if (context.router.canPop()) {
          context.router.pop(true);
          return;
        }
        context.read<DetailFeedCubit>().load();
      },
    );
  }
}

enum _FeedDetailAction { edit, delete }

part of 'pg_display_feed_entry.dart';

class _DisplayFeedEntry extends StatelessWidget {
  const _DisplayFeedEntry();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedModeCubit, DisplayFeedModeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.feedTitle),
            actions: [_FeedDisplayModeToggler(state: state)],
          ),
          body: state.when(
            list: () => const _FeedEntryListView(),
            calendar: (_) => const _FeedEntryCalendarView(),
          ),
        );
      },
    );
  }
}

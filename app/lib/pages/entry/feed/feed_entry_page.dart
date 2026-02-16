import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'feed_entry_screen.dart';
part 'feed_entry_list_section.dart';
part 'feed_entry_tile_widget.dart';
part 'feed_entry_failure_section.dart';
part 'feed_entry_error_banner_widget.dart';
part 'feed_entry_empty_section.dart';

@RoutePage()
class FeedEntryPage extends StatelessWidget {
  const FeedEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayFeedListBloc>()
            ..add(DisplayFeedListEvent.started()),
      child: const _FeedEntryScreen(),
    );
  }
}

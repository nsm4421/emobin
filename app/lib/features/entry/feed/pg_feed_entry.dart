import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_feed/feature_feed.dart' hide FeedEntry;
import 'package:feature_feed/feature_feed.dart' as ff show FeedEntry;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_feed_entry.dart';
part 'fg_feed_entry_list.dart';
part 'wd_feed_entry_tile.dart';
part 'fg_feed_entry_failure.dart';
part 'wd_feed_entry_error_banner.dart';
part 'fg_feed_entry_empty.dart';

@RoutePage(name: 'FeedEntryRoute')
class FeedEntry extends StatelessWidget {
  const FeedEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayFeedListBloc>()
            ..add(DisplayFeedListEvent.started()),
      child: const _FeedEntry(),
    );
  }
}

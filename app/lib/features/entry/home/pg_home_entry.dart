import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_home_entry.dart';
part 'fg_home_feed_status.dart';
part 'fg_home_write_entry.dart';
part 'fg_home_sync_backup.dart';
part 'fg_home_quick_actions.dart';
part 'wd_home_status_metric.dart';
part 'wd_home_quick_action.dart';

@RoutePage(name: 'HomeEntryRoute')
class HomeEntry extends StatelessWidget {
  const HomeEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayFeedListBloc>()
            ..add(const DisplayFeedListEvent.started()),
      child: const _HomeEntryScreen(),
    );
  }
}

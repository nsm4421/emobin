import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_display_feed_entry.dart';

part 'wd_feed_display_mode_toggler.dart';

part 'list/fg_feed_entry_list_view.dart';

part 'list/wd_feed_entry_tile.dart';

part 'list/fg_feed_entry_failure.dart';

part 'list/wd_feed_entry_error_banner.dart';

part 'list/fg_feed_entry_empty.dart';

part 'calendar/fg_feed_entry_calendar_view.dart';

part 'calendar/wd_feed_calendar_month_tabs.dart';

part 'calendar/wd_feed_calendar_month_grid.dart';

part 'calendar/wd_feed_calendar_day_cell.dart';

part 'calendar/wd_feed_calendar_summary.dart';

@RoutePage(name: 'FeedEntryRoute')
class DisplayFeedEntry extends StatelessWidget {
  const DisplayFeedEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<DisplayFeedModeCubit>()),
        BlocProvider(create: (_) => GetIt.instance<DisplayFeedListBloc>()),
        BlocProvider(create: (_) => GetIt.instance<DisplayFeedCalendarBloc>()),
      ],
      child: const _DisplayFeedEntry(),
    );
  }
}

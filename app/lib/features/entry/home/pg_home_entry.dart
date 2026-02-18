import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('HOME')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _HomeFeedStatus(),
            SizedBox(height: 16),
            _HomeWriteEntry(),
            SizedBox(height: 16),
            _HomeSyncBackup(),
            SizedBox(height: 16),
            _HomeQuickActions(),
          ],
        ),
      ),
    );
  }
}

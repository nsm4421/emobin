import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_feed_status_section.dart';
part 'home_write_entry_section.dart';
part 'home_sync_backup_section.dart';
part 'home_quick_actions_section.dart';
part 'home_status_metric_widget.dart';
part 'home_quick_action_widget.dart';

@RoutePage()
class HomeEntryScreen extends StatelessWidget {
  const HomeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOME')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _HomeFeedStatusSection(),
            SizedBox(height: 16),
            _HomeWriteEntrySection(),
            SizedBox(height: 16),
            _HomeSyncBackupSection(),
            SizedBox(height: 16),
            _HomeQuickActionsSection(),
          ],
        ),
      ),
    );
  }
}

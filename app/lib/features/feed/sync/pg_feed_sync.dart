import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:flutter/material.dart';

part 'sc_feed_sync.dart';

@RoutePage(name: 'FeedSyncRoute')
class FeedSync extends StatelessWidget {
  const FeedSync({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeedSyncScreen();
  }
}

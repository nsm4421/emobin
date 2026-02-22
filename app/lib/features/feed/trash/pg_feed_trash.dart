import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_feed_trash.dart';

part 'wd_feed_item.dart';

@RoutePage(name: 'FeedTrashRoute')
class FeedTrash extends StatelessWidget {
  const FeedTrash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<FeedTrashCubit>()..load(),
      child: const _FeedTrashScreen(),
    );
  }
}

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_feed_detail.dart';
part 'fg_feed_detail_status.dart';
part 'fg_feed_detail_content.dart';
part 'wd_feed_detail_meta_row.dart';

@RoutePage(name: 'FeedDetailRoute')
class FeedDetail extends StatelessWidget {
  const FeedDetail({super.key, required this.feedId});

  final String feedId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<DetailFeedCubit>(param1: feedId),
      child: const _FeedDetailScreen(),
    );
  }
}

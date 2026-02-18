import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/features/feed/create/wd_feed_editor_hashtag.dart';
import 'package:emobin/features/feed/create/wd_feed_editor_image.dart';
import 'package:emobin/features/feed/create/wd_feed_editor_note.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_edit_feed.dart';
part 'fg_edit_feed_intro.dart';
part 'fg_edit_feed_hashtag.dart';
part 'fg_edit_feed_note.dart';
part 'fg_edit_feed_image.dart';
part 'wd_edit_feed_submit.dart';

@RoutePage(name: 'EditFeedRoute')
class EditFeed extends StatelessWidget {
  const EditFeed({super.key, required this.feedId});

  final String feedId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<EditFeedCubit>(param1: feedId),
        ),
        BlocProvider(
          create: (_) => GetIt.instance<FeedHashtagPresetCubit>()..initialize(),
        ),
      ],
      child: BlocListener<EditFeedCubit, EditFeedState>(
        listener: (context, state) {
          state.whenOrNull(
            idle: (failure) {
              if (failure == null) return;
              ToastHelper.error(failure.message);
              if (context.router.canPop()) {
                context.router.pop();
              }
            },
            editing: (_, failure) {
              if (failure == null) return;
              ToastHelper.error(failure.message);
              final cubit = context.read<EditFeedCubit>();
              Future.delayed(const Duration(seconds: 1), () {
                if (!context.mounted) return;
                cubit.reset();
              });
            },
            updated: (updated) {
              ToastHelper.success('updated!');
              if (context.router.canPop()) {
                context.router.pop<FeedEntry>(updated);
              }
            },
          );
        },
        child: const _EditFeed(),
      ),
    );
  }
}

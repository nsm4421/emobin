import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:emobin/features/feed/create/wd_feed_editor_hashtag.dart';
import 'package:emobin/features/feed/create/wd_feed_editor_image.dart';
import 'package:emobin/features/feed/create/wd_feed_editor_note.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_create_feed.dart';

part 'fg_create_feed_intro.dart';

part 'fg_create_feed_hashtag.dart';

part 'fg_create_feed_note.dart';

part 'fg_create_feed_image.dart';

part 'wd_submit_buttons.dart';

@RoutePage(name: 'CreateFeedRoute')
class CreateFeed extends StatelessWidget {
  const CreateFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<CreateFeedCubit>()),
        BlocProvider(
          create: (_) => GetIt.instance<FeedHashtagPresetCubit>()..initialize(),
        ),
      ],
      child: BlocListener<CreateFeedCubit, CreateFeedState>(
        listener: (context, state) {
          final created = state.created;
          if (created != null && state.isCreated && context.router.canPop()) {
            ToastHelper.success('created!');
            context.router.pop<FeedEntry>(created);
            return;
          }

          final failure = state.failure;
          if (failure != null) {
            ToastHelper.error(failure.message);
            final cubit = context.read<CreateFeedCubit>();
            Future.delayed(const Duration(seconds: 1), cubit.reset);
          }
        },
        child: const _CreateFeed(),
      ),
    );
  }
}

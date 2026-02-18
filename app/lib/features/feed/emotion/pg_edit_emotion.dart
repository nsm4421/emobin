import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_edit_emotion.dart';

part 'fg_emotion_intro.dart';

part 'fg_emotion_input.dart';

part 'fg_emotion_list.dart';

@RoutePage(name: 'EditEmotionRoute')
class EditEmotion extends StatelessWidget {
  const EditEmotion({super.key, this.cubit});

  final FeedEmotionPresetCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final maybeCubit = cubit;
    final child = BlocListener<FeedEmotionPresetCubit, FeedEmotionPresetState>(
      listenWhen: (prev, curr) => curr.failure != null,
      listener: (context, state) {
        final failure = state.failure;
        if (failure != null) {
          ToastHelper.error(failure);
        }
      },
      child: const _EditEmotion(),
    );

    if (maybeCubit != null) {
      return BlocProvider.value(value: maybeCubit, child: child);
    }

    return BlocProvider(
      create: (_) => GetIt.instance<FeedEmotionPresetCubit>()..initialize(),
      child: child,
    );
  }
}

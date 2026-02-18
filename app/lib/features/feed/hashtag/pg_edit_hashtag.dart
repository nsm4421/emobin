import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_edit_hashtag.dart';

part 'fg_hashtag_intro.dart';

part 'fg_hashtag_input.dart';

part 'fg_hashtag_list.dart';

@RoutePage(name: 'EditHashtagRoute')
class EditHashtag extends StatelessWidget {
  const EditHashtag({super.key, this.cubit});

  final FeedHashtagPresetCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final maybeCubit = cubit;
    final child = BlocListener<FeedHashtagPresetCubit, FeedHashtagPresetState>(
      listenWhen: (prev, curr) => curr.failure != null,
      listener: (context, state) {
        final failure = state.failure;
        if (failure != null) {
          ToastHelper.error(failure);
        }
      },
      child: const _EditHashtag(),
    );

    if (maybeCubit != null) {
      return BlocProvider.value(value: maybeCubit, child: child);
    }

    return BlocProvider(
      create: (_) => GetIt.instance<FeedHashtagPresetCubit>()..initialize(),
      child: child,
    );
  }
}

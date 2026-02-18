import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sc_sign_up.dart';

@RoutePage(name: 'SignUpRoute')
class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignUpCubit>(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (_) => context.router.replaceAll([const EntryRoute()]),
            failure: (failure) {
              ToastHelper.error(failure.message);
              Future.delayed(const Duration(seconds: 1), () {
                if (!context.mounted) return;
                context.read<SignUpCubit>().reset();
              });
            },
          );
        },
        child: const _SignUp(),
      ),
    );
  }
}

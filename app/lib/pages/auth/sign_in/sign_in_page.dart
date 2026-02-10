import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sign_in_screen.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignInCubit>(),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (_) => context.router.replaceAll([const HomeRoute()]),
            failure: (failure) {
              ToastHelper.error(failure.message);
              Future.delayed(const Duration(seconds: 1), () {
                if (!context.mounted) return;
                context.read<SignInCubit>().reset();
              });
            },
          );
        },
        child: const _SignInScreen(),
      ),
    );
  }
}

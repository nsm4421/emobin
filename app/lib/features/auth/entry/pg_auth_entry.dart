import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_setting/feature_setting.dart';

import 'package:emobin/router/app_router.dart';

part 'fg_auth_entry_background.dart';
part 'fg_auth_entry_features.dart';

@RoutePage(name: 'AuthEntryRoute')
class AuthEntry extends StatelessWidget {
  const AuthEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _AuthEntryBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colorScheme.outlineVariant,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                          color: context.colorScheme.shadow.withAlpha(31),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 36,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Emobin',
                  style: context.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in or create an account to continue.',
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const _AuthEntryFeatures(),
                const Spacer(),
                AppPrimaryButton(
                  label: 'Sign In',
                  onPressed: () => context.router.push(const SignInRoute()),
                ),
                const SizedBox(height: 12),
                AppOutlinedButton(
                  label: 'Sign Up',
                  onPressed: () => context.router.push(const SignUpRoute()),
                  fullWidth: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'Create an account in under a minute.',
                  style: context.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

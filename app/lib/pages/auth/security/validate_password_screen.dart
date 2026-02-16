import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_security/feature_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ValidatePasswordScreen extends StatefulWidget {
  const ValidatePasswordScreen({super.key});

  @override
  State<ValidatePasswordScreen> createState() => _ValidatePasswordScreenState();
}

class _ValidatePasswordScreenState extends State<ValidatePasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _passwordController;

  static const int _minPasswordLength = 4;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String get _password => _passwordController.text.trim();

  String? _validatePassword(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) return 'Please enter a password.';
    if (input.length < _minPasswordLength)
      return 'Use at least $_minPasswordLength characters.';
    return null;
  }

  void _onValidatePressed() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate();

    if (ok == null || !ok) return;
    context.read<SecurityBloc>().add(
      SecurityEvent.verifyPasswordRequested(_password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, state) {
        final failure = state.failure;
        if (failure != null && !state.unLocked) {
          ToastHelper.error(failure.message);
          return;
        }

        if (state.unLocked) {
          ToastHelper.success('Password Verified!');
          context.router.replaceAll([EntryRoute()]);
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Validate Password')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const AppFormHeader(
                    title: 'Verify your password for security',
                    subtitle: 'Enter your account password to continue.',
                  ),
                  const SizedBox(height: 32),
                  AppPasswordField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    onFieldSubmitted: (_) => _onValidatePressed(),
                  ),
                  const SizedBox(height: 8),
                  AppPrimaryButton(
                    label: 'Confirm',
                    onPressed: state.isLoading ? null : _onValidatePressed,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

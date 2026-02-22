import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_security/feature_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage(name: 'ValidatePasswordRoute')
class ValidatePassword extends StatefulWidget {
  const ValidatePassword({super.key});

  @override
  State<ValidatePassword> createState() => _ValidatePasswordState();
}

class _ValidatePasswordState extends State<ValidatePassword> {
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
    if (input.isEmpty) {
      return context.l10n.pleaseEnterPassword;
    }
    if (input.length < _minPasswordLength) {
      return context.l10n.atLeastCharacters(_minPasswordLength);
    }
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
          ToastHelper.success(context.l10n.passwordVerifiedToast);
          context.router.replaceAll([EntryRoute()]);
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.validatePasswordTitle)),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  AppFormHeader(
                    title: context.l10n.validatePasswordHeader,
                    subtitle: context.l10n.validatePasswordSubtitle,
                  ),
                  const SizedBox(height: 32),
                  AppPasswordField(
                    controller: _passwordController,
                    label: context.l10n.password,
                    hintText: context.l10n.enterYourPasswordHint,
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    onFieldSubmitted: (_) => _onValidatePressed(),
                  ),
                  const SizedBox(height: 8),
                  AppPrimaryButton(
                    label: context.l10n.confirm,
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

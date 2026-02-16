part of '../setting_entry_screen.dart';

enum _PasswordEditAction { set, change }

class _SettingSecuritySection extends StatelessWidget {
  const _SettingSecuritySection();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listenWhen: (previous, current) => current.failure != null,
      listener: (context, state) {
        final failure = state.failure;
        if (failure != null) {
          ToastHelper.error(failure.message);
        }
      },
      builder: (context, state) {
        final hasPassword =
            state.whenOrNull(unlocked: (_, hasPassword) => hasPassword) ??
            false;
        return _SettingSectionCardWidget(
          title: 'Security',
          children: [
            hasPassword
                ? _HasPasswordWidget()
                : _HasNotPasswordWidget(),
          ],
        );
      },
    );
  }
}

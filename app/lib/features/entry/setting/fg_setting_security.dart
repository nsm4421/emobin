part of 'pg_setting_entry.dart';

enum _PasswordEditAction { set, change }

class _SettingSecurity extends StatelessWidget {
  const _SettingSecurity();

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
        return _SettingSectionCard(
          title: 'Security',
          children: [hasPassword ? _HasPassword() : _HasNotPassword()],
        );
      },
    );
  }
}

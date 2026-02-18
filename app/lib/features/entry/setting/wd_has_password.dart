part of 'pg_setting_entry.dart';

class _HasPassword extends StatelessWidget {
  const _HasPassword();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async => await showModalBottomSheet(
            context: context,
            builder: (_) => _EditPasswordModal(_PasswordEditAction.change),
          ),
          child: const _SettingTile(
            icon: Icons.lock_reset_rounded,
            title: 'Change Password',
            subtitle: 'Set a new password.',
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<SecurityBloc>().add(
              SecurityEvent.deletePasswordRequested(),
            );
          },
          child: _SettingTile(
            icon: Icons.lock_open_rounded,
            title: 'Disable Password',
            subtitle: 'Remove the app lock password.',
            titleColor: context.colorScheme.error,
            showBottomDivider: false,
          ),
        ),
      ],
    );
  }
}

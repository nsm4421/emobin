part of 'pg_setting_entry.dart';

class _HasNotPassword extends StatelessWidget {
  const _HasNotPassword();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await showModalBottomSheet(
        context: context,
        builder: (_) => _EditPasswordModal(_PasswordEditAction.set),
      ),
      child: const _SettingTile(
        icon: Icons.lock_outline_rounded,
        title: 'Set Password',
        subtitle: 'Set up a password for app lock.',
        showBottomDivider: false,
      ),
    );
  }
}

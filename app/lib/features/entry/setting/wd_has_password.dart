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
          child: _SettingTile(
            icon: Icons.lock_reset_rounded,
            title: context.l10n.changePassword,
            subtitle: context.l10n.changePasswordSubtitle,
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
            title: context.l10n.disablePassword,
            subtitle: context.l10n.disablePasswordSubtitle,
            titleColor: context.colorScheme.error,
            showBottomDivider: false,
          ),
        ),
      ],
    );
  }
}

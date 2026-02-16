part of '../setting_entry_screen.dart';

class _HasNotPasswordWidget extends StatelessWidget {
  const _HasNotPasswordWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await showModalBottomSheet(
        context: context,
        builder: (_) => _EditPasswordModalWidget(_PasswordEditAction.set),
      ),
      child: const _SettingTileWidget(
        icon: Icons.lock_outline_rounded,
        title: 'Set Password',
        subtitle: 'Set up a password for app lock.',
        showBottomDivider: false,
      ),
    );
  }
}

part of '../setting_entry_screen.dart';

class _HasPasswordWidget extends StatelessWidget {
  const _HasPasswordWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async => await showModalBottomSheet(
            context: context,
            builder: (_) =>
                _EditPasswordModalWidget(_PasswordEditAction.change),
          ),
          child: const _SettingTileWidget(
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
          child: _SettingTileWidget(
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

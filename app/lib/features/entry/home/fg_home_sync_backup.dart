part of 'pg_home_entry.dart';

class _HomeSyncBackup extends StatelessWidget {
  const _HomeSyncBackup();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sync & Backup',
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        _HomeQuickAction(
          icon: Icons.sync_rounded,
          title: 'Sync Now',
          subtitle: 'Upload pending entries and refresh latest data.',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sync started (mockup)')),
          ),
        ),
        const SizedBox(height: 10),
        _HomeQuickAction(
          icon: Icons.backup_rounded,
          title: 'Backup Settings',
          subtitle: 'Configure cloud backup and restore options.',
          onTap: () => _onBackupTapped(context),
        ),
      ],
    );
  }

  Future<void> _onBackupTapped(BuildContext context) async {
    final isAuthenticated =
        context.read<AuthBloc>().state.whenOrNull(authenticated: (_) => true) ??
        false;

    if (isAuthenticated) {
      // TODO : 백업페이지로 이동
      return;
    }

    await _showSignInRequiredDialog(context);
  }

  Future<void> _showSignInRequiredDialog(BuildContext context) async {
    final router = context.router;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text(
            'To use backup, please sign in or create an account first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                router.push(const SignInRoute());
              },
              child: const Text('Sign In'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                router.push(const SignUpRoute());
              },
              child: const Text('Sign Up'),
            ),
          ],
        );
      },
    );
  }
}

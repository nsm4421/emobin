part of 'pg_setting_entry.dart';

class _SettingHero extends StatelessWidget {
  const _SettingHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary.withAlpha(22),
            context.colorScheme.tertiary.withAlpha(16),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return state.when(
            authenticated: (authUser) {
              final username = (authUser.userMetadata['username'] as String?)
                  ?.trim();
              final email = authUser.email?.trim();
              final displayName = (username != null && username.isNotEmpty)
                  ? username
                  : (email != null && email.isNotEmpty ? email : authUser.id);

              return Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: context.colorScheme.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: context.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          email ?? context.l10n.signedInUser,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            unAuthenticated: () => Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: context.colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.welcome,
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.signInBackupSyncMessage,
                        style: context.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonal(
                            onPressed: () =>
                                context.router.push(const SignInRoute()),
                            child: Text(context.l10n.signIn),
                          ),
                          OutlinedButton(
                            onPressed: () =>
                                context.router.push(const SignUpRoute()),
                            child: Text(context.l10n.signUp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            unKnown: () => Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.checkingAccountStatus,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

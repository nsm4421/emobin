part of 'pg_setting_entry.dart';

class _EditPasswordModalState extends State<_EditPasswordModal> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  static const int _minPasswordLength = 4;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String? _validatePasswordConfirm(String? value) {
    if ((value ?? '').trim() != _password) {
      return context.l10n.passwordsDoNotMatch;
    }
    return null;
  }

  void _submit() {
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate();
    if (ok == null || !ok) {
      return;
    }
    context
      ..read<SecurityBloc>().add(SecurityEvent.savePasswordRequested(_password))
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(switch (widget._action) {
              _PasswordEditAction.set => l10n.passwordModalSetTitle,
              _PasswordEditAction.change => l10n.passwordModalChangeTitle,
            }, style: context.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              l10n.passwordModalDescription(_minPasswordLength),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            AppPasswordField(
              controller: _passwordController,
              label: l10n.newPassword,
              hintText: l10n.enterPassword,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
            ),
            const SizedBox(height: 12),
            AppPasswordField(
              controller: _confirmPasswordController,
              label: l10n.confirmPassword,
              hintText: l10n.reenterPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validatePasswordConfirm,
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: switch (widget._action) {
                _PasswordEditAction.set => l10n.setAction,
                _PasswordEditAction.change => l10n.changeAction,
              },
              onPressed: _submit,
            ),
            const SizedBox(height: 8),
            AppTextButton(
              label: l10n.cancel,
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

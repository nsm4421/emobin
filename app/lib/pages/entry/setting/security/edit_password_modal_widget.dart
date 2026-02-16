part of '../setting_entry_screen.dart';

class _EditPasswordModalWidget extends StatefulWidget {
  const _EditPasswordModalWidget(this._action, {super.key});

  final _PasswordEditAction _action;

  @override
  State<_EditPasswordModalWidget> createState() =>
      _EditPasswordModalWidgetState();
}

class _EditPasswordModalWidgetState extends State<_EditPasswordModalWidget> {
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
    if (input.isEmpty) return 'Please enter a password.';
    if (input.length < _minPasswordLength)
      return 'Use at least $_minPasswordLength characters.';
    return null;
  }

  String? _validatePasswordConfirm(String? value) {
    if ((value ?? '').trim() != _password) {
      return 'Passwords do not match.';
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
              _PasswordEditAction.set => 'Set Password',
              _PasswordEditAction.change => 'Change Password',
            }, style: context.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Enter a password with at least $_minPasswordLength characters.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            AppPasswordField(
              controller: _passwordController,
              label: 'New Password',
              hintText: 'Enter password',
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
            ),
            const SizedBox(height: 12),
            AppPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hintText: 'Re-enter password',
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validatePasswordConfirm,
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: switch (widget._action) {
                _PasswordEditAction.set => 'Set',
                _PasswordEditAction.change => 'Change',
              },
              onPressed: _submit,
            ),
            const SizedBox(height: 8),
            AppTextButton(
              label: 'Cancel',
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

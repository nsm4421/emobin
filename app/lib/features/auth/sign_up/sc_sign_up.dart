part of 'pg_sign_up.dart';

class _SignUp extends StatefulWidget {
  const _SignUp();

  @override
  State<_SignUp> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUp> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<SignUpCubit>().submit(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final isButtonDisabled = state.maybeWhen(
          loading: () => true,
          failure: (_) => true,
          orElse: () => false,
        );

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text(context.l10n.signUp)),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  AppFormHeader(
                    title: context.l10n.createAccount,
                    subtitle: context.l10n.startJourneySubtitle,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    label: context.l10n.username,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.enterYourUsername;
                      }
                      if (value.trim().length < 2) {
                        return context.l10n.atLeastTwoCharacters;
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    label: context.l10n.email,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.enterYourEmail;
                      }
                      if (!value.contains('@')) {
                        return context.l10n.invalidEmail;
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  AppPasswordField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    label: context.l10n.password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.enterAPassword;
                      }
                      if (value.length < 6) {
                        return context.l10n.atLeastCharacters(6);
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  AppPasswordField(
                    controller: _confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    label: context.l10n.confirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.confirmYourPassword;
                      }
                      if (value != _passwordController.text) {
                        return context.l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: context.l10n.signUp,
                    onPressed: isButtonDisabled ? null : _onSubmit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 12),
                  AppTextButton(
                    label: context.l10n.back,
                    onPressed: isLoading ? null : () => context.router.pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

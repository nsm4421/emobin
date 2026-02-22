part of 'pg_sign_in.dart';

class _SignIn extends StatefulWidget {
  const _SignIn();

  @override
  State<_SignIn> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignIn> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<SignInCubit>().submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
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
          appBar: AppBar(title: Text(context.l10n.signIn)),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  AppFormHeader(
                    title: context.l10n.welcomeBack,
                    subtitle: context.l10n.signInContinueSubtitle,
                  ),
                  const SizedBox(height: 32),
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
                    textInputAction: TextInputAction.done,
                    label: context.l10n.password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.enterYourPassword;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: context.l10n.signIn,
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

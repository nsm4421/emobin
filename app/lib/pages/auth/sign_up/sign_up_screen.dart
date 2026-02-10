part of 'sign_up_page.dart';

class _SignUpScreen extends StatefulWidget {
  const _SignUpScreen({super.key});

  @override
  State<_SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<_SignUpScreen> {
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
          appBar: AppBar(title: const Text('Sign Up')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const AppFormHeader(
                    title: 'Create account',
                    subtitle: 'Start your journey with Emobin.',
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    label: 'Username',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your username.';
                      }
                      if (value.trim().length < 2) {
                        return 'Use at least 2 characters.';
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
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your email.';
                      }
                      if (!value.contains('@')) {
                        return 'Invalid email.';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  AppPasswordField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    label: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password.';
                      }
                      if (value.length < 6) {
                        return 'Use at least 6 characters.';
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
                    label: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password.';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: 'Sign Up',
                    onPressed: isButtonDisabled ? null : _onSubmit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 12),
                  AppTextButton(
                    label: 'Back',
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

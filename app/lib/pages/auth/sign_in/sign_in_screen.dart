part of 'sign_in_page.dart';

class _SignInScreen extends StatefulWidget {
  const _SignInScreen({super.key});

  @override
  State<_SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<_SignInScreen> {
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
          appBar: AppBar(title: const Text('Sign In')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const AppFormHeader(
                    title: 'Welcome back',
                    subtitle: 'Sign in to continue.',
                  ),
                  const SizedBox(height: 32),
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
                    textInputAction: TextInputAction.done,
                    label: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: 'Sign In',
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

import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );

    if (!fullWidth) return button;

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: onPressed,
      child: Text(label),
    );

    if (!fullWidth) return button;

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );

    if (!fullWidth) return button;

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}

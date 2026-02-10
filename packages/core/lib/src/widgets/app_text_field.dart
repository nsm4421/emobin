import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.helperText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.obscureText = false,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      obscureText: obscureText,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
      ),
    );
  }
}

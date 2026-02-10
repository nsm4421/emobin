import 'package:flutter/material.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.helperText,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.initiallyObscured = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? helperText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool initiallyObscured;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.initiallyObscured;
  }

  void _toggleVisibility() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      obscureText: _obscured,
      autofillHints: widget.autofillHints,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        helperText: widget.helperText,
        suffixIcon: IconButton(
          onPressed: widget.enabled ? _toggleVisibility : null,
          tooltip: _obscured ? 'Show password' : 'Hide password',
          icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// Password field with show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.textDirection,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      validator: widget.validator,
      obscureText: _obscureText,
      textDirection: widget.textDirection,
      suffix: IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
      ),
    );
  }
}

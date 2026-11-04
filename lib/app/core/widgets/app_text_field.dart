import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Text field with label above.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.obscureText = false,
    this.textDirection,
    this.fillColor,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool obscureText;
  final TextDirection? textDirection;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.space8),
            child: Text(
              label!,
              style: AppTextStyles.label,
              textAlign: TextAlign.start,
            ),
          ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          maxLength: maxLength,
          obscureText: obscureText,
          textDirection: textDirection,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffix,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Reusable button with variants.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    Widget child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                icon!,
                const SizedBox(width: AppDimens.space8),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          );

    final ButtonStyle style = _buttonStyle(isEnabled);

    final Widget button = ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: style,
      child: child,
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: AppDimens.buttonHeight,
        child: button,
      );
    }

    return SizedBox(
      height: AppDimens.buttonHeight,
      child: button,
    );
  }

  ButtonStyle _buttonStyle(bool isEnabled) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
          ),
          textStyle: AppTextStyles.buttonLabel,
        );
      case AppButtonVariant.soft:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.lavender,
          foregroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
          ),
          textStyle: AppTextStyles.buttonLabel,
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
          ),
          textStyle: AppTextStyles.buttonLabel,
        );
    }
  }
}

enum AppButtonVariant { primary, soft, text }

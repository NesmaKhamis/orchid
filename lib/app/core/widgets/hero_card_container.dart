import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

/// Visual style variant for [HeroCardContainer].
enum HeroCardVariant {
  /// Lavender background with soft purple border tint.
  standard,

  /// Soft mint background with gentle success border tint.
  completed,
}

/// Reusable tinted hero card shell with lavender or soft mint surface,
/// primary or success border tint, and card radius.
class HeroCardContainer extends StatelessWidget {
  const HeroCardContainer({
    super.key,
    required this.child,
    this.variant = HeroCardVariant.standard,
    this.padding = const EdgeInsets.all(AppDimens.space16),
  });

  final Widget child;
  final HeroCardVariant variant;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = variant == HeroCardVariant.completed;
    final Color bgColor = isCompleted ? AppColors.softMint : AppColors.lavender;
    final Color borderColor = isCompleted
        ? AppColors.success.withValues(alpha: 0.35)
        : AppColors.primary.withValues(alpha: 0.2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

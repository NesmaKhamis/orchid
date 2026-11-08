import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

/// Reusable tinted hero card shell with lavender surface, primary border tint, and card radius.
class HeroCardContainer extends StatelessWidget {
  const HeroCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimens.space20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }
}

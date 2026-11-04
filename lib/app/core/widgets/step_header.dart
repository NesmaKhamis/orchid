import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Registration step header with step label, title, back chevron and lock badge.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.stepLabel,
    required this.title,
    this.onBack,
  });

  final String stepLabel;
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textDark,
          iconSize: 24,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            width: 48,
            height: 48,
          ),
        ),
        const SizedBox(width: AppDimens.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                stepLabel,
                textAlign: TextAlign.start,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSubtitle,
                ),
              ),
              const SizedBox(height: AppDimens.space4),
              Text(
                title,
                textAlign: TextAlign.start,
                style: AppTextStyles.h2,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.space12),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

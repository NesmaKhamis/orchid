import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

enum SectionCardTone { lavender, softMint, softYellow, softPink, white }

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.tone = SectionCardTone.white,
    this.showArrow = true,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final SectionCardTone tone;
  final bool showArrow;

  Color _getBackgroundColor() {
    switch (tone) {
      case SectionCardTone.lavender:
        return AppColors.lavender;
      case SectionCardTone.softMint:
        return AppColors.softMint;
      case SectionCardTone.softYellow:
        return AppColors.softYellow;
      case SectionCardTone.softPink:
        return AppColors.softPink;
      case SectionCardTone.white:
        return AppColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            icon!,
            const SizedBox(width: AppDimens.space12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title, style: AppTextStyles.label),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: AppDimens.space4),
                  Text(subtitle!, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppDimens.space8),
            trailing!,
          ] else if (showArrow) ...<Widget>[
            const SizedBox(width: AppDimens.space8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: card,
      );
    }
    return card;
  }
}

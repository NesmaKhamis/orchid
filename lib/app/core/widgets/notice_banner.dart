import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Notice banner with tone.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner({
    super.key,
    required this.tone,
    this.icon,
    required this.text,
  });

  final NoticeBannerTone tone;
  final Widget? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final _BannerStyle style = _getStyle();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusField),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            icon!,
            const SizedBox(width: AppDimens.space12),
          ],
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: style.textColor),
            ),
          ),
        ],
      ),
    );
  }

  _BannerStyle _getStyle() {
    switch (tone) {
      case NoticeBannerTone.info:
        return const _BannerStyle(
          backgroundColor: AppColors.lavender,
          textColor: AppColors.textDark,
        );
      case NoticeBannerTone.warning:
        return const _BannerStyle(
          backgroundColor: AppColors.softYellow,
          textColor: AppColors.textDark,
        );
      case NoticeBannerTone.success:
        return const _BannerStyle(
          backgroundColor: AppColors.softMint,
          textColor: AppColors.textDark,
        );
      case NoticeBannerTone.danger:
        return const _BannerStyle(
          backgroundColor: AppColors.softPink,
          textColor: AppColors.textDark,
        );
    }
  }
}

class _BannerStyle {
  const _BannerStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;
}

enum NoticeBannerTone { info, warning, success, danger }

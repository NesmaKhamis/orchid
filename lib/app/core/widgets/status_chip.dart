import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Small pill label.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusChipTone.success,
  });

  final String label;
  final StatusChipTone tone;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = switch (tone) {
      StatusChipTone.success => AppColors.softMint,
      StatusChipTone.info => AppColors.lavender,
      StatusChipTone.danger => AppColors.softPink,
      StatusChipTone.warning => AppColors.softYellow,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textDark),
      ),
    );
  }
}

enum StatusChipTone { success, info, danger, warning }

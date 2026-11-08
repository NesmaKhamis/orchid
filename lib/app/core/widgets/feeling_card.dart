import 'package:flutter/material.dart';

import '../../data/models/feeling.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'selectable_card.dart';

/// Card representing a single feeling with a large emoji and an Arabic label.
class FeelingCard extends StatelessWidget {
  const FeelingCard({
    super.key,
    required this.feeling,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor = AppColors.lavender,
  });

  final Feeling feeling;
  final bool isSelected;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      selected: isSelected,
      onTap: onTap,
      color: isSelected
          ? backgroundColor.withValues(alpha: 0.9)
          : backgroundColor.withValues(alpha: 0.45),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Large emoji placeholder for orchid face
          // TODO: replace emoji with orchid face asset
          Text(
            feeling.emoji,
            style: const TextStyle(fontSize: 38),
          ),
          const SizedBox(height: AppDimens.space4),
          Text(
            feeling.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textDark,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

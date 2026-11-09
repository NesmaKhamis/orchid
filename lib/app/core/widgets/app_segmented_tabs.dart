import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Reusable segmented tab bar with equal-width buttons.
class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < labels.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Material(
              color: i == selectedIndex
                  ? AppColors.primary
                  : AppColors.lavender,
              borderRadius: BorderRadius.circular(AppDimens.radiusButton),
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 42),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space4,
                    vertical: AppDimens.space8,
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      labels[i],
                      style: AppTextStyles.chipLabel.copyWith(
                        color: i == selectedIndex
                            ? AppColors.white
                            : AppColors.textDark,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

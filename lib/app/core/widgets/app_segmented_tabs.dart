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
                  height: 42,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space4,
                  ),
                  child: Text(
                    labels[i],
                    style: AppTextStyles.label.copyWith(
                      color: i == selectedIndex
                          ? AppColors.white
                          : AppColors.textDark,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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

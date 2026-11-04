import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Labelled checkbox tile with a tinted background.
class AppCheckboxTile extends StatelessWidget {
  const AppCheckboxTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.tone = AppCheckboxTileTone.lavender,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final AppCheckboxTileTone tone;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onChanged != null;
    final Color backgroundColor = switch (tone) {
      AppCheckboxTileTone.lavender => AppColors.lavender,
      AppCheckboxTileTone.mint => AppColors.softMint,
      AppCheckboxTileTone.pink => AppColors.softPink,
    };

    return Semantics(
      checked: value,
      child: GestureDetector(
        onTap: isEnabled ? () => onChanged!(!value) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.space16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusField),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                value: value,
                onChanged: isEnabled
                    ? (bool? nextValue) => onChanged!(nextValue ?? false)
                    : null,
                activeColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.space4),
                ),
              ),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimens.space12),
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textDark,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AppCheckboxTileTone { lavender, mint, pink }

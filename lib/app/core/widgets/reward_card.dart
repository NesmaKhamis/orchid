import 'package:flutter/material.dart';

import '../../data/models/reward_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'status_chip.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({
    super.key,
    required this.item,
    required this.currentBalance,
    this.index = 0,
    this.onTap,
  });

  final RewardItem item;
  final int currentBalance;
  final int index;
  final VoidCallback? onTap;

  static const List<Color> _pastelTones = <Color>[
    AppColors.softPink,
    AppColors.softMint,
    AppColors.softBlue,
    AppColors.softYellow,
    AppColors.lavender,
  ];

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = item.isOutOfStock;
    final int missingCoins = currentBalance >= item.cost
        ? 0
        : item.cost - currentBalance;
    final double coinProgress = item.cost > 0
        ? (currentBalance / item.cost).clamp(0.0, 1.0)
        : 1.0;

    final Color toneColor = _pastelTones[index % _pastelTones.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.space12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Reward placeholder with large emoji on rotated pastel background
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: toneColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusField),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 36),
                ), // TODO: replace emoji with final reward image
              ),
              const SizedBox(height: AppDimens.space8),
              // Title
              Text(
                item.title,
                style: AppTextStyles.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimens.space4),
              // Cost
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.monetization_on_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: AppDimens.space4),
                  Text(
                    '${item.cost} عملة',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Status / Action
              if (isOutOfStock)
                const Center(
                  child: StatusChip(
                    label: 'نفدت الكمية',
                    tone: StatusChipTone.danger,
                  ),
                )
              else if (missingCoins > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'ناقصك $missingCoins عملة',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.space4),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusChip),
                      child: LinearProgressIndicator(
                        value: coinProgress,
                        minHeight: 6,
                        backgroundColor: AppColors.inputBg,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.lavender,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Container(
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusButton),
                  ),
                  child: Text(
                    'أطلبها',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
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

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'animated_orchid.dart';
import 'hero_card_container.dart';

class CoinBalanceCard extends StatelessWidget {
  const CoinBalanceCard({
    super.key,
    required this.balance,
    required this.todayEarned,
    required this.dailyCap,
    this.encouragingText = 'أنت تبدع كل يوم، استمر في جمع البهجة!',
  });

  final int balance;
  final int todayEarned;
  final int dailyCap;
  final String encouragingText;

  @override
  Widget build(BuildContext context) {
    final double progress = dailyCap > 0
        ? (todayEarned / dailyCap).clamp(0.0, 1.0)
        : 0.0;

    return HeroCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const AnimatedOrchid(size: 72, autoStart: true),
              const SizedBox(width: AppDimens.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'رصيد عملاتي',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: AppDimens.space4),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.monetization_on_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                        const SizedBox(width: AppDimens.space8),
                        Text(
                          '$balance عملة',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                          ),
                        )
                            .animate(key: ValueKey<int>(balance))
                            .scale(
                              duration: 350.ms,
                              curve: Curves.easeOutBack,
                            )
                            .fadeIn(),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space4),
                    Text(
                      encouragingText,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space16),
          // Soft progress bar for today's coins vs cap
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'عملات اليوم ($todayEarned / $dailyCap)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              if (todayEarned >= dailyCap)
                Text(
                  'وصلت للحد اليومي! 🌟',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimens.space8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusChip),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

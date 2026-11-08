import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      body: const RewardsContent(),
    );
  }
}

class RewardsContent extends StatelessWidget {
  const RewardsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('المكافآت والهدايا', style: AppTextStyles.h1),
          const SizedBox(height: AppDimens.space8),
          const Text(
            'اجمع عملاتك وافتح مكافآت جديدة.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppDimens.space24),
          Container(
            padding: const EdgeInsets.all(AppDimens.space24),
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: const Row(
              children: <Widget>[
                Icon(
                  Icons.monetization_on_rounded,
                  color: AppColors.primary,
                  size: 44,
                ),
                SizedBox(width: AppDimens.space16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('رصيد العملات', style: AppTextStyles.label),
                    SizedBox(height: AppDimens.space4),
                    Text('120 عملة', style: AppTextStyles.h2),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          const Text('مكافآتي', style: AppTextStyles.title),
          const SizedBox(height: AppDimens.space12),
          _RewardTile(
            icon: Icons.card_giftcard_rounded,
            title: 'هدية الأوركيد',
            subtitle: 'افتحها عند جمع 200 عملة',
            color: AppColors.softPink,
          ),
          const SizedBox(height: AppDimens.space12),
          _RewardTile(
            icon: Icons.local_activity_rounded,
            title: 'قسيمة نشاط ممتع',
            subtitle: 'متاحة عند جمع 300 عملة',
            color: AppColors.softYellow,
          ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppDimens.space12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppDimens.radiusField),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.label),
                const SizedBox(height: AppDimens.space4),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_entrance.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/coin_balance_card.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/request_status_chip.dart';
import '../../../core/widgets/reward_card.dart';
import '../../../core/widgets/section_card.dart';
import '../../../data/models/daily_activity.dart';
import '../../../data/models/reward_item.dart';
import '../../../data/models/reward_request.dart';
import '../../../routes/app_routes.dart';
import '../controllers/rewards_controller.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      background: AppScaffoldBackground.cream,
      body: RewardsContent(),
    );
  }
}

class RewardsContent extends GetView<RewardsController> {
  const RewardsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NoticeBanner(
                  tone: NoticeBannerTone.danger,
                  text: controller.errorMessage.value,
                ),
                const SizedBox(height: AppDimens.space16),
                AppButton(
                  label: 'إعادة المحاولة',
                  onPressed: controller.loadRewardsData,
                  fullWidth: false,
                ),
              ],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppDimens.space16,
          bottom: AppDimens.space32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Header title
            const Text(
              'المكافآت والهدايا',
              style: AppTextStyles.h1,
            ).animatedEntrance(),
            const SizedBox(height: AppDimens.space4),
            Text(
              'اجمع عملاتك وافتح مكافآت جديدة.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSubtitle,
              ),
            ).animatedEntrance(
              delay: const Duration(milliseconds: 50),
            ),
            const SizedBox(height: AppDimens.space20),

            // 1. Balance card
            CoinBalanceCard(
              balance: controller.balance.value,
              todayEarned: controller.todayEarned.value,
              dailyCap: controller.dailyCap,
            ).animatedEntrance(
              delay: const Duration(milliseconds: 100),
            ),
            const SizedBox(height: AppDimens.space28),

            // 2. How to earn coins section
            const Text(
              'كيف أجمع عملات؟',
              style: AppTextStyles.title,
            ).animatedEntrance(
              delay: const Duration(milliseconds: 150),
            ),
            const SizedBox(height: AppDimens.space4),
            Text(
              'أكمل أنشطتك الممتعة اليوم واكسب المزيد من العملات',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ).animatedEntrance(
              delay: const Duration(milliseconds: 180),
            ),
            const SizedBox(height: AppDimens.space12),
            _buildDailyActivitiesList(controller.dailyActivities),
            const SizedBox(height: AppDimens.space28),

            // 3. Available rewards grid
            const Text(
              'المكافآت المتاحة',
              style: AppTextStyles.title,
            ).animatedEntrance(
              delay: const Duration(milliseconds: 200),
            ),
            const SizedBox(height: AppDimens.space4),
            Text(
              'اختر هديتك المفضلة واستلمها بحب من مركز الأوركيد',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ).animatedEntrance(
              delay: const Duration(milliseconds: 220),
            ),
            const SizedBox(height: AppDimens.space12),
            _buildRewardsGrid(
              controller.rewards,
              controller.balance.value,
            ),
            const SizedBox(height: AppDimens.space28),

            // 4. My requests preview
            _buildRequestsHeader(controller.requests.length),
            const SizedBox(height: AppDimens.space12),
            _buildRequestsPreview(controller.requests),
          ],
        ),
      );
    });
  }

  Widget _buildDailyActivitiesList(List<DailyActivity> activities) {
    if (activities.isEmpty) {
      return const NoticeBanner(
        tone: NoticeBannerTone.info,
        text: 'لا توجد أنشطة متاحة اليوم.',
      );
    }

    return Column(
      children: <Widget>[
        for (int i = 0; i < activities.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppDimens.space8),
          _DailyActivityItem(activity: activities[i]),
        ],
      ],
    );
  }

  Widget _buildRewardsGrid(List<RewardItem> items, int currentBalance) {
    if (items.isEmpty) {
      return const NoticeBanner(
        tone: NoticeBannerTone.info,
        text: 'لا توجد مكافآت معروضة حالياً. تابعنا قريباً!',
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: AppDimens.space12,
        crossAxisSpacing: AppDimens.space12,
      ),
      itemBuilder: (BuildContext context, int index) {
        final RewardItem item = items[index];
        return RewardCard(
          item: item,
          currentBalance: currentBalance,
          onTap: () {
            Get.toNamed(Routes.rewardDetails, arguments: item);
          },
        );
      },
    );
  }

  Widget _buildRequestsHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'طلباتي',
          style: AppTextStyles.title,
        ),
        if (count > 0)
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.myRewardRequests);
            },
            child: Text(
              'عرض الكل ($count)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRequestsPreview(List<RewardRequest> requests) {
    if (requests.isEmpty) {
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
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppDimens.radiusField),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimens.space12),
            const Expanded(
              child: Text(
                'لم تطلب أي مكافأة بعد. اجمع العملات واطلب هديتك الأولى!',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    final List<RewardRequest> previewList = requests.take(2).toList();
    return Column(
      children: <Widget>[
        for (int i = 0; i < previewList.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppDimens.space8),
          SectionCard(
            tone: SectionCardTone.white,
            icon: Container(
              padding: const EdgeInsets.all(AppDimens.space8),
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppDimens.radiusChip),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: previewList[i].rewardTitle,
            subtitle: 'التكلفة: ${previewList[i].cost} عملة',
            trailing: RequestStatusChip(status: previewList[i].status),
            showArrow: false,
            onTap: () {
              Get.toNamed(Routes.myRewardRequests);
            },
          ),
        ],
      ],
    );
  }
}

class _DailyActivityItem extends StatelessWidget {
  const _DailyActivityItem({required this.activity});

  final DailyActivity activity;

  @override
  Widget build(BuildContext context) {
    final bool isDone = activity.isCompleted;
    final bool hasRoute = activity.route != null && !isDone;

    return SectionCard(
      tone: isDone ? SectionCardTone.softMint : SectionCardTone.white,
      icon: Container(
        padding: const EdgeInsets.all(AppDimens.space8),
        decoration: BoxDecoration(
          color: isDone ? AppColors.softMint : AppColors.inputBg,
          borderRadius: BorderRadius.circular(AppDimens.radiusChip),
        ),
        child: Icon(
          isDone ? Icons.check_circle_rounded : Icons.stars_rounded,
          color: isDone ? AppColors.success : AppColors.primary,
          size: 20,
        ),
      ),
      title: activity.title,
      subtitle: isDone
          ? 'تم الحصول على +${activity.coins} عملة'
          : '+${activity.coins} عملة',
      showArrow: hasRoute,
      onTap: hasRoute
          ? () {
              Get.toNamed(activity.route!);
            }
          : null,
    );
  }
}

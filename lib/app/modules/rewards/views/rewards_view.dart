import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
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
      scrollable: false,
      body: RewardsContent(),
    );
  }
}

class RewardsContent extends GetView<RewardsController> {
  const RewardsContent({super.key});

  static const List<String> _tabLabels = <String>[
    'كيف أجمع؟',
    'المكافآت',
    'طلباتي',
  ];

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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: AppDimens.space12),

          // Fixed Top: Header
          const Text(
            'المكافآت والهدايا',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: AppDimens.space4),
          Text(
            'اجمع عملاتك وافتح مكافآت جديدة.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSubtitle,
            ),
          ),
          const SizedBox(height: AppDimens.space16),

          // Fixed Top: Balance Card
          CoinBalanceCard(
            balance: controller.balance.value,
            todayEarned: controller.todayEarned.value,
            dailyCap: controller.dailyCap,
          ),
          const SizedBox(height: AppDimens.space16),

          // Fixed Top: Segmented Tabs (3 equal-width buttons)
          AppSegmentedTabs(
            labels: _tabLabels,
            selectedIndex: controller.selectedTab.value,
            onChanged: (int index) => controller.selectedTab.value = index,
          ),
          const SizedBox(height: AppDimens.space12),

          // Expanded: Content of selected tab with smooth fade
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildTabContent(controller.selectedTab.value),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _buildActivitiesTab();
      case 1:
        return _buildRewardsTab();
      case 2:
      default:
        return _buildRequestsTab();
    }
  }

  Widget _buildActivitiesTab() {
    if (controller.dailyActivities.isEmpty) {
      return const Center(
        key: ValueKey<int>(0),
        child: NoticeBanner(
          tone: NoticeBannerTone.info,
          text: 'لا توجد أنشطة متاحة اليوم.',
        ),
      );
    }

    return ListView.separated(
      key: const ValueKey<int>(0),
      padding: const EdgeInsets.only(
        top: AppDimens.space4,
        bottom: AppDimens.space24,
      ),
      itemCount: controller.dailyActivities.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: AppDimens.space8),
      itemBuilder: (BuildContext context, int index) {
        return _DailyActivityItem(
          activity: controller.dailyActivities[index],
        );
      },
    );
  }

  Widget _buildRewardsTab() {
    if (controller.rewards.isEmpty) {
      return const Center(
        key: ValueKey<int>(1),
        child: NoticeBanner(
          tone: NoticeBannerTone.info,
          text: 'لا توجد مكافآت معروضة حالياً. تابعنا قريباً!',
        ),
      );
    }

    return GridView.builder(
      key: const ValueKey<int>(1),
      padding: const EdgeInsets.only(
        top: AppDimens.space4,
        bottom: AppDimens.space24,
      ),
      itemCount: controller.rewards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: AppDimens.space12,
        crossAxisSpacing: AppDimens.space12,
      ),
      itemBuilder: (BuildContext context, int index) {
        final RewardItem item = controller.rewards[index];
        return RewardCard(
          item: item,
          index: index,
          currentBalance: controller.balance.value,
          onTap: () {
            Get.toNamed(Routes.rewardDetails, arguments: item);
          },
        );
      },
    );
  }

  Widget _buildRequestsTab() {
    if (controller.requests.isEmpty) {
      return Center(
        key: const ValueKey<int>(2),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Container(
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
          ),
        ),
      );
    }

    return ListView.separated(
      key: const ValueKey<int>(2),
      padding: const EdgeInsets.only(
        top: AppDimens.space4,
        bottom: AppDimens.space24,
      ),
      itemCount: controller.requests.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: AppDimens.space12),
      itemBuilder: (BuildContext context, int index) {
        final RewardRequest request = controller.requests[index];
        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildRequestCard(RewardRequest request) {
    final bool isReady = request.status == RewardRequestStatus.ready;

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(
          color: isReady
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.border,
          width: isReady ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  request.rewardTitle,
                  style: AppTextStyles.title,
                ),
              ),
              const SizedBox(width: AppDimens.space8),
              RequestStatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: AppDimens.space8),
          Row(
            children: <Widget>[
              const Icon(
                Icons.monetization_on_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: AppDimens.space4),
              Text(
                '${request.cost} عملة',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.textMuted,
                size: 14,
              ),
              const SizedBox(width: AppDimens.space4),
              Text(
                AppDateUtils.format(request.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          if (request.status == RewardRequestStatus.ready) ...<Widget>[
            const SizedBox(height: AppDimens.space12),
            NoticeBanner(
              tone: NoticeBannerTone.success,
              icon: const Icon(
                Icons.celebration_rounded,
                color: AppColors.success,
              ),
              text: 'المكافأة جاهزة للاستلام! 🎉\n${request.pickupInstructions}',
            ),
          ],
        ],
      ),
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

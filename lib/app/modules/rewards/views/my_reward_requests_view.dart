import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/request_status_chip.dart';
import '../../../data/models/reward_request.dart';
import '../controllers/my_reward_requests_controller.dart';

class MyRewardRequestsView extends GetView<MyRewardRequestsController> {
  const MyRewardRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      title: 'طلباتي من المكافآت',
      showBackButton: true,
      body: Obx(() {
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
                    onPressed: controller.loadRequests,
                    fullWidth: false,
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.requests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.space24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(AppDimens.space20),
                    decoration: const BoxDecoration(
                      color: AppColors.lavender,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space20),
                  const Text(
                    'لا توجد طلبات حتى الآن',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    'اجمع عملاتك من الأنشطة اليومية واطلب مكافآتك المفضلة!',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.space24),
                  AppButton(
                    label: 'تصفح المكافآت',
                    variant: AppButtonVariant.primary,
                    fullWidth: false,
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.space16,
          ),
          itemCount: controller.requests.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: AppDimens.space12),
          itemBuilder: (BuildContext context, int index) {
            final RewardRequest request = controller.requests[index];
            return _RewardRequestCard(request: request);
          },
        );
      }),
    );
  }
}

class _RewardRequestCard extends StatelessWidget {
  const _RewardRequestCard({required this.request});

  final RewardRequest request;

  @override
  Widget build(BuildContext context) {
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
          // Header: Title & Status Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  request.rewardTitle,
                  style: AppTextStyles.cardTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDimens.space12),
              RequestStatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: AppDimens.space12),

          // Meta row: Cost & Date
          Row(
            children: <Widget>[
              const Icon(
                Icons.monetization_on_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: AppDimens.space4),
              Flexible(
                child: Text(
                  '${request.cost} عملة',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.textMuted,
                size: 14,
              ),
              const SizedBox(width: AppDimens.space4),
              Flexible(
                child: Text(
                  AppDateUtils.format(request.createdAt),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space12),

          // Status Notice / Instructions
          if (request.status == RewardRequestStatus.ready)
            NoticeBanner(
              tone: NoticeBannerTone.success,
              icon: const Icon(
                Icons.celebration_rounded,
                color: AppColors.success,
              ),
              text: 'المكافأة جاهزة للاستلام! 🎉\n${request.pickupInstructions}',
            )
          else if (request.status == RewardRequestStatus.review)
            const NoticeBanner(
              tone: NoticeBannerTone.warning,
              icon: Icon(
                Icons.hourglass_top_rounded,
                color: AppColors.primary,
              ),
              text: 'طلبك قيد المراجعة حالياً من قبل فريق مركز الأوركيد.',
            )
          else if (request.status == RewardRequestStatus.pending)
            const NoticeBanner(
              tone: NoticeBannerTone.info,
              icon: Icon(
                Icons.access_time_rounded,
                color: AppColors.primary,
              ),
              text: 'تم استلام طلبك وبانتظار المراجعة.',
            )
          else if (request.status == RewardRequestStatus.received)
            const NoticeBanner(
              tone: NoticeBannerTone.info,
              icon: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
              ),
              text: 'تم استلام المكافأة بنجاح. نرجو أن تسعدك!',
            ),
        ],
      ),
    );
  }
}

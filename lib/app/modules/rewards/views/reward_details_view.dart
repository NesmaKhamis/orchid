import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_orchid.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/parent_gate_dialog.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/reward_request.dart';
import '../../../routes/app_routes.dart';
import '../controllers/reward_details_controller.dart';

class RewardDetailsView extends GetView<RewardDetailsController> {
  const RewardDetailsView({super.key});

  void _showCelebrationDialog(BuildContext context, RewardRequest request) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            backgroundColor: AppColors.white,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenHorizontalPadding,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.space24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ...List.generate(6, (int index) {
                        final double angle = (index * 60) * pi / 180;
                        return Transform.translate(
                          offset: Offset(cos(angle) * 44, sin(angle) * 44),
                          child: Icon(
                            index.isEven
                                ? Icons.auto_awesome_rounded
                                : Icons.favorite_rounded,
                            color: index.isEven
                                ? AppColors.paletteYellow
                                : AppColors.palettePink,
                            size: 20,
                          ),
                        )
                            .animate()
                            .scale(
                              delay: (index * 70).ms,
                              duration: 500.ms,
                              curve: Curves.easeOutBack,
                            )
                            .fadeIn();
                      }),
                      const AnimatedOrchid(size: 80, autoStart: true)
                          .animate()
                          .scale(
                            duration: 350.ms,
                            curve: Curves.easeOutBack,
                          ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space20),
                  Text(
                    'مبارك يا بطل! 🎉',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    'تم إرسال طلبك (${request.rewardTitle}) بنجاح وهو الآن قيد المراجعة.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.space16),
                  NoticeBanner(
                    tone: NoticeBannerTone.info,
                    text: 'تعليمات الاستلام: ${request.pickupInstructions}',
                  ),
                  const SizedBox(height: AppDimens.space20),
                  AppButton(
                    label: 'عرض في طلباتي',
                    variant: AppButtonVariant.primary,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Get.offNamed(Routes.myRewardRequests);
                    },
                  ),
                  const SizedBox(height: AppDimens.space8),
                  AppButton(
                    label: 'العودة للمكافآت',
                    variant: AppButtonVariant.soft,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      title: 'تفاصيل المكافأة',
      showBackButton: true,
      scrollable: true,
      body: Obx(() {
        final bool isOutOfStock = controller.isOutOfStock;
        final bool hasEnoughCoins = controller.hasEnoughCoins;
        final int missingCoins = controller.missingCoins;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: AppDimens.space8),

            // Reward Image Card
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      controller.reward.emoji,
                      style: const TextStyle(fontSize: 72),
                    ), // TODO: replace emoji with final reward image
                  ),
                  if (isOutOfStock)
                    const PositionedDirectional(
                      top: AppDimens.space12,
                      start: AppDimens.space12,
                      child: StatusChip(
                        label: 'نفدت الكمية',
                        tone: StatusChipTone.danger,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space20),

            // Title & Cost Card
            Container(
              padding: const EdgeInsets.all(AppDimens.space16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    controller.reward.title,
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: AppDimens.space12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.monetization_on_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            const SizedBox(width: AppDimens.space8),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  '${controller.reward.cost} عملة',
                                  style: AppTextStyles.h1.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.space8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.space12,
                            vertical: AppDimens.space4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lavender,
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusChip),
                          ),
                          child: Text(
                            'رصيدك: ${controller.balance.value} عملة',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space16),

            // Description Card
            Container(
              padding: const EdgeInsets.all(AppDimens.space16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'عن المكافأة',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    controller.reward.description,
                    style: AppTextStyles.body.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space16),

            // Pickup Instructions
            NoticeBanner(
              tone: NoticeBannerTone.info,
              icon: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
              ),
              text: 'طريقة ومكان الاستلام:\n${controller.reward.pickupInstructions}',
            ),

            if (!isOutOfStock && !hasEnoughCoins) ...<Widget>[
              const SizedBox(height: AppDimens.space12),
              NoticeBanner(
                tone: NoticeBannerTone.warning,
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                ),
                text: 'ينقصك $missingCoins عملة لطلب هذه المكافأة. أكمل أنشطتك اليومية الممتعة لتحصل عليها!',
              ),
            ],

            const SizedBox(height: AppDimens.space28),

            // Redeem Action Button
            if (isOutOfStock)
              const AppButton(
                label: 'عذراً، نفدت الكمية حالياً',
                onPressed: null,
              )
            else if (!hasEnoughCoins)
              AppButton(
                label: 'ناقصك $missingCoins عملة',
                onPressed: null,
              )
            else
              AppButton(
                label: 'أطلبها الآن ✨',
                isLoading: controller.isRedeeming.value,
                onPressed: () async {
                  final bool passedGate = await showParentGateDialog(context);
                  if (!passedGate) return;

                  final RewardRequest? result = await controller.redeem();
                  if (result != null && context.mounted) {
                    _showCelebrationDialog(context, result);
                  }
                },
              ),
            const SizedBox(height: AppDimens.space32),
          ],
        );
      }),
    );
  }
}

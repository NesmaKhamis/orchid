import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_entrance.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/orchid_image.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/step_header.dart';
import '../../../routes/app_routes.dart';
import '../controllers/verification_rejected_controller.dart';

class VerificationRejectedView extends GetView<VerificationRejectedController> {
  const VerificationRejectedView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StepHeader(
            stepLabel: '01 / تعذّر استكمال التسجيل',
            title: 'لكل مرحلة ما يناسبها',
            onBack: () => Get.back(),
          ),
          const SizedBox(height: AppDimens.space24),
          AnimatedEntrance(
            child: Center(
              child: OrchidImage(
                assetPath: AppAssets.orchidFaceHappy,
                width: 170,
                height: 170,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: StatusChip(
              label: 'العمر خارج الفئة المعتمدة',
              tone: StatusChipTone.danger,
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          AnimatedEntrance(
            delay: const Duration(milliseconds: 100),
            child: NoticeBanner(
              tone: NoticeBannerTone.danger,
              text:
                  'نعتذر منك، لا يمكنك الدخول للتطبيق حيث أن الفئة العمرية المعتمدة هي من '
                  '${AppConstants.minChildAge} إلى ${AppConstants.maxChildAge} سنة فقط '
                  'لضمان سلامة وجودة المحتوى والدعم النفسي.',
              textStyle: AppTextStyles.title.copyWith(height: 1.6),
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          Text(
            'العمر في هذا المثال: ${controller.age} سنة، بحسب تاريخ الميلاد في بيانات التحقق التجريبية.',
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppDimens.space24),
          AppButton(
            label: 'مراجعة البيانات',
            onPressed: () => Get.back(),
          ),
          const SizedBox(height: AppDimens.space12),
          AppButton(
            label: 'العودة إلى البداية',
            variant: AppButtonVariant.soft,
            onPressed: () => Get.offAllNamed(Routes.onboarding),
          ),
          const SizedBox(height: AppDimens.space16),
          Text(
            'إذا كانت البيانات غير صحيحة، يمكن لولي الأمر طلب المساعدة قبل إعادة المحاولة.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppDimens.space8),
        ],
      ),
    );
  }
}

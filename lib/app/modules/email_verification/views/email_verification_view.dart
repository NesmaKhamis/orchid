import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/orchid_image.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Align(
            alignment: AlignmentDirectional.topStart,
            child: AppBackButton(),
          ),
          const SizedBox(height: AppDimens.space20),
          const Center(
            child: OrchidImage(
              assetPath: AppAssets.messageSquareLock,
              width: 72,
              height: 72,
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          Text(
            'تأكيد البريد الإلكتروني',
            textAlign: TextAlign.start,
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: AppDimens.space12),
          Text(
            'أرسلنا رابط تأكيد إلى Gmail الخاص بك. افتح الرابط ثم عد إلى هنا للمتابعة.',
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          AppTextField(
            controller: controller.emailController,
            label: 'البريد الإلكتروني',
            readOnly: true,
            textDirection: TextDirection.ltr,
            fillColor: AppColors.white,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          Obx(
            () => AppButton(
              label: 'تم التأكيد، تابع',
              isLoading: controller.isLoading.value,
              onPressed: controller.canContinue ? controller.confirm : null,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          Obx(
            () => AppButton(
              label: controller.canResend
                  ? 'إعادة إرسال الرابط'
                  : 'إعادة إرسال الرابط خلال ${controller.countdownLabel}',
              variant: AppButtonVariant.text,
              onPressed: controller.canResend ? controller.resendLink : null,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          const NoticeBanner(
            tone: NoticeBannerTone.info,
            icon: Icon(
              Icons.mark_email_read_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            text:
                'تحقق من صندوق الوارد أو البريد غير المرغوب فيه إذا لم تجد الرابط.',
          ),
          const SizedBox(height: AppDimens.space8),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/orchid_image.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../core/widgets/step_header.dart';
import '../controllers/phone_verification_controller.dart';

class PhoneVerificationView extends GetView<PhoneVerificationController> {
  const PhoneVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StepHeader(
            stepLabel: '02 / تأكيد الهاتف • 4 من 4',
            title: 'نتأكد من هاتفك',
            onBack: () => Get.back(),
          ),
          const SizedBox(height: AppDimens.space32),
          const Center(
            child: OrchidImage(
              assetPath: AppAssets.messageSquareLock,
              width: 72,
              height: 72,
            ),
          ),
          const SizedBox(height: AppDimens.space32),
          Text(
            'رمز واحد... ونبدأ',
            textAlign: TextAlign.start,
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: AppDimens.space20),
          AppTextField(
            controller: controller.phoneController,
            label: 'هاتف ولي الأمر',
            readOnly: true,
            textDirection: TextDirection.ltr,
            fillColor: AppColors.white,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          Text(
            'أدخل رمز التفعيل من 6 أرقام الوارد برسالة SMS '
            'إلى هاتف ولي الأمر.',
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          OtpInput(
            length: AppConstants.otpLength,
            controller: controller.otpInputController,
            onChanged: controller.onOtpChanged,
          ),
          const SizedBox(height: AppDimens.space12),
          Obx(() {
            if (controller.canResend) {
              return Center(
                child: GestureDetector(
                  onTap: controller.resendCode,
                  child: Text(
                    'إعادة إرسال الرمز',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            return Center(
              child: Text(
                'إعادة إرسال الرمز خلال ${controller.countdownLabel}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            );
          }),
          const SizedBox(height: AppDimens.space20),
          Obx(
            () => AppButton(
              label: 'تأكيد الهاتف',
              isLoading: controller.isLoading.value,
              onPressed: controller.canConfirm ? controller.confirm : null,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          AppButton(
            label: 'تعديل رقم الهاتف',
            variant: AppButtonVariant.soft,
            onPressed: () => Get.back(),
          ),
          const SizedBox(height: AppDimens.space20),
          const NoticeBanner(
            tone: NoticeBannerTone.warning,
            icon: Icon(
              Icons.science_outlined,
              color: AppColors.textDark,
              size: 22,
            ),
            text:
                'هذا رمز تجريبي لعرض الشاشة. لم تُرسل رسالة SMS. '
                'إذا كان الرمز خاطئاً يظهر: «الرمز غير صحيح، حاول مجدداً» '
                'دون إكمال التفعيل.',
          ),
          const SizedBox(height: AppDimens.space8),
        ],
      ),
    );
  }
}

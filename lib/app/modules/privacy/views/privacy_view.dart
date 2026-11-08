import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_checkbox_tile.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/status_chip.dart';
import '../controllers/privacy_controller.dart';

class PrivacyView extends GetView<PrivacyController> {
  const PrivacyView({super.key});

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
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: StatusChip(
              label: 'يراجعها ولي الأمر',
              tone: StatusChipTone.info,
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          Text(
            'نشارك ما يساعد،\nونحمي ما يخصّه.',
            textAlign: TextAlign.start,
            style: AppTextStyles.h1.copyWith(height: 1.35),
          ),
          const SizedBox(height: AppDimens.space20),
          const _PrivacyInfoCard(),
          const SizedBox(height: AppDimens.space20),
          Obx(
            () => AppCheckboxTile(
              label:
                  'أوافق على مشاركة تقارير مشاعر طفلي وتقييماته مع '
                  'الأخصائيين الميدانيين المعتمدين بالمؤسسة لأغراض الدعم.',
              value: controller.consentGiven.value,
              onChanged: controller.setConsent,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          Obx(
            () => AppButton(
              label: 'أوافق وأتابع',
              onPressed: controller.canContinue
                  ? controller.proceedToPhoneVerification
                  : null,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          NoticeBanner(
            tone: NoticeBannerTone.info,
            icon: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            text:
                'عند عدم الموافقة لا يُستكمل هذا المسار. يمكن مراجعة '
                'الموافقة وطلب سحبها لاحقاً من إعدادات ولي الأمر. '
                'حالة واجهة فقط.',
          ),
          const SizedBox(height: AppDimens.space8),
        ],
      ),
    );
  }
}

class _PrivacyInfoCard extends StatelessWidget {
  const _PrivacyInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'ما الذي يطّلع عليه الأخصائي؟',
            textAlign: TextAlign.start,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            'تقارير المشاعر والتقييمات المرتبطة بالأنشطة. لدعم '
            'الطفل في الورشات داخل المؤسسة.',
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSubtitle,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          Text(
            'من يمكنه الاطلاع؟',
            textAlign: TextAlign.start,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            'ولي الأمر والأخصائيون الميدانيون المعتمدون بالمؤسسة '
            'فقط. حسب دورهم.',
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSubtitle,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.space16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.success,
                size: AppDimens.space16,
              ),
              const SizedBox(width: AppDimens.space8),
              Expanded(
                child: Text(
                  'الرسومات والتسجيلات الصوتية خاصة بالطفل وولي أمره. '
                  'ولا تُنشر للعامة.',
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

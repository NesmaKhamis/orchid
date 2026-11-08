import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_entrance.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/workshop_model.dart';
import '../controllers/my_workshops_controller.dart';

class MyWorkshopsView extends GetView<MyWorkshopsController> {
  const MyWorkshopsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppHeaderBar(title: 'ورشاتي المسجلة', onBackPressed: Get.back),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.hasError.value) {
                return _RegisteredWorkshopsError(
                  onRetry: controller.loadBookedWorkshops,
                );
              }
              if (controller.workshops.isEmpty) {
                return const _EmptyRegisteredWorkshops();
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppDimens.screenHorizontalPadding,
                  AppDimens.space8,
                  AppDimens.screenHorizontalPadding,
                  AppDimens.space24,
                ),
                itemCount: controller.workshops.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppDimens.space16),
                itemBuilder: (BuildContext context, int index) {
                  final WorkshopModel workshop = controller.workshops[index];
                  return RegisteredWorkshopCard(
                    workshop: workshop,
                    isCancelling:
                        controller.cancellingWorkshopId.value == workshop.id,
                    onDetailsPressed: () => controller.openDetails(workshop),
                    onCancelPressed: () => controller.cancelBooking(workshop),
                  ).animatedEntrance(delay: Duration(milliseconds: index * 80));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RegisteredWorkshopCard extends StatelessWidget {
  const RegisteredWorkshopCard({
    super.key,
    required this.workshop,
    required this.isCancelling,
    required this.onDetailsPressed,
    required this.onCancelPressed,
  });

  final WorkshopModel workshop;
  final bool isCancelling;
  final VoidCallback onDetailsPressed;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.softMint,
                    borderRadius: BorderRadius.circular(AppDimens.radiusField),
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: AppColors.success,
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: Text(workshop.title, style: AppTextStyles.title),
                ),
                const StatusChip(label: 'حجز مؤكد'),
              ],
            ),
            const SizedBox(height: AppDimens.space16),
            _RegisteredInfoRow(
              icon: Icons.calendar_today_outlined,
              text: workshop.date,
            ),
            const SizedBox(height: AppDimens.space8),
            _RegisteredInfoRow(
              icon: Icons.schedule_outlined,
              text: workshop.time,
            ),
            const SizedBox(height: AppDimens.space8),
            _RegisteredInfoRow(
              icon: Icons.location_on_outlined,
              text: workshop.location,
            ),
            const SizedBox(height: AppDimens.space16),
            AppButton(
              label: 'عرض التفاصيل',
              variant: AppButtonVariant.soft,
              onPressed: onDetailsPressed,
              icon: const Icon(Icons.visibility_outlined, size: 20),
            ),
            const SizedBox(height: AppDimens.space4),
            AppButton(
              label: 'إلغاء الحجز',
              variant: AppButtonVariant.primary,
              isLoading: isCancelling,
              onPressed: isCancelling ? null : onCancelPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisteredInfoRow extends StatelessWidget {
  const _RegisteredInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.textSubtitle),
        const SizedBox(width: AppDimens.space8),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ],
    );
  }
}

class _RegisteredWorkshopsError extends StatelessWidget {
  const _RegisteredWorkshopsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppDimens.space12),
            const Text('لا يمكن تحميل ورشاتي الآن', style: AppTextStyles.title),
            const SizedBox(height: AppDimens.space16),
            AppButton(
              label: 'إعادة المحاولة',
              onPressed: onRetry,
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRegisteredWorkshops extends StatelessWidget {
  const _EmptyRegisteredWorkshops();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: AppColors.lavender,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_rounded,
                color: AppColors.primary,
                size: 52,
              ),
            ),
            const SizedBox(height: AppDimens.space20),
            const Text(
              'لا توجد ورشات مسجلة بعد',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.space8),
            const Text(
              'احجز ورشة مناسبة لطفلك وستظهر هنا.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

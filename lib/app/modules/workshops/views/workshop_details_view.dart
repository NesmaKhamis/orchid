import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_checkbox_tile.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/workshop_model.dart';
import '../controllers/workshop_details_controller.dart';

class WorkshopDetailsView extends GetView<WorkshopDetailsController> {
  const WorkshopDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppHeaderBar(title: 'تفاصيل الورشة', onBackPressed: Get.back),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppDimens.screenHorizontalPadding,
                AppDimens.space8,
                AppDimens.screenHorizontalPadding,
                AppDimens.space24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _WorkshopHero(workshop: controller.workshop),
                  const SizedBox(height: AppDimens.space16),
                  _WorkshopDetailsCard(workshop: controller.workshop),
                  const SizedBox(height: AppDimens.space16),
                  _WorkshopPlanCard(workshop: controller.workshop),
                  const SizedBox(height: AppDimens.space16),
                  Obx(
                    () => AppCheckboxTile(
                      label: 'أؤكد حضور سليم برفقة ولي أمره طوال الورشة',
                      value: controller.hasConsent.value,
                      onChanged: controller.isBooked.value
                          ? null
                          : controller.setConsent,
                      tone: AppCheckboxTileTone.lavender,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space16),
                  Obx(
                    () => AppButton(
                      label: controller.isBooked.value
                          ? 'تم تأكيد الحجز'
                          : 'تأكيد حجز الطفل والمرافق',
                      icon: Icon(
                        controller.isBooked.value
                            ? Icons.check_circle_outline_rounded
                            : Icons.event_available_rounded,
                        size: 20,
                      ),
                      isLoading: controller.isBooking.value,
                      onPressed: controller.isBooked.value
                          ? null
                          : () => _bookAndCelebrate(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bookAndCelebrate(BuildContext context) async {
    final bool booked = await controller.bookWorkshop();
    if (!booked || !context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => const _BookingSuccessSheet(),
    );
  }
}

class _WorkshopHero extends StatelessWidget {
  const _WorkshopHero({required this.workshop});

  final WorkshopModel workshop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: StatusChip(label: 'ورشة حضورية'),
          ),
          const SizedBox(height: AppDimens.space8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _WorkshopBadge(
              label: 'متبقي ${workshop.remainingSpots} مقاعد',
              color: AppColors.softYellow,
              icon: Icons.event_seat_rounded,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Text(workshop.title, style: AppTextStyles.h2)),
              const SizedBox(width: AppDimens.space8),
              _WorkshopBadge(
                label: workshop.ageRange,
                color: AppColors.lavender,
                icon: Icons.child_care_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            workshop.description,
            style: AppTextStyles.body.copyWith(height: 1.7),
          ),
        ],
      ),
    );
  }
}

class _WorkshopBadge extends StatelessWidget {
  const _WorkshopBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 132),
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppDimens.space8,
        AppDimens.space4,
        AppDimens.space8,
        AppDimens.space4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: AppColors.textSubtitle),
          const SizedBox(width: AppDimens.space4),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkshopDetailsCard extends StatelessWidget {
  const _WorkshopDetailsCard({required this.workshop});

  final WorkshopModel workshop;

  @override
  Widget build(BuildContext context) {
    return _DetailsSection(
      title: 'معلومات الورشة',
      icon: Icons.info_outline_rounded,
      child: Column(
        children: <Widget>[
          _DetailRow(
            icon: Icons.child_care_rounded,
            label: 'الفئة العمرية',
            value: workshop.ageRange,
          ),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'المكان',
            value: workshop.location,
          ),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'التاريخ',
            value: workshop.date,
          ),
          _DetailRow(
            icon: Icons.schedule_outlined,
            label: 'الوقت',
            value: workshop.time,
          ),
          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'المشرف',
            value: workshop.supervisor,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _WorkshopPlanCard extends StatelessWidget {
  const _WorkshopPlanCard({required this.workshop});

  final WorkshopModel workshop;

  @override
  Widget build(BuildContext context) {
    return _DetailsSection(
      title: 'ماذا سنفعل؟',
      icon: Icons.auto_awesome_rounded,
      child: Column(
        children: <Widget>[
          for (final String activity in workshop.activities)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.space12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimens.space8),
                  Expanded(child: Text(activity, style: AppTextStyles.body)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: AppDimens.space8),
              Text(title, style: AppTextStyles.title),
            ],
          ),
          const SizedBox(height: AppDimens.space16),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.textSubtitle, size: 20),
          const SizedBox(width: AppDimens.space8),
          Text('$label: ', style: AppTextStyles.label),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _BookingSuccessSheet extends StatelessWidget {
  const _BookingSuccessSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.space24,
          AppDimens.space24,
          AppDimens.space24,
          AppDimens.space16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusCard),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.softMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration_rounded,
                color: AppColors.success,
                size: 42,
              ),
            ),
            const SizedBox(height: AppDimens.space16),
            const Text('تم تسجيل الورشة بنجاح!', style: AppTextStyles.h2),
            const SizedBox(height: AppDimens.space8),
            const Text(
              'أصبح الحجز متاحاً في قائمة ورشاتي المسجلة.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.space20),
            AppButton(
              label: 'حسناً',
              onPressed: Get.back,
              icon: const Icon(Icons.check_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

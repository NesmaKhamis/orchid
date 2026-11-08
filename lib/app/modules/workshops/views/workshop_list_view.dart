import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_entrance.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../data/models/workshop_model.dart';
import '../controllers/workshop_list_controller.dart';

class WorkshopListView extends GetView<WorkshopListController> {
  const WorkshopListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppHeaderBar(
            title: 'ورش الدعم النفسي والاجتماعي',
            onBackPressed: Get.back,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppDimens.screenHorizontalPadding,
              0,
              AppDimens.screenHorizontalPadding,
              AppDimens.space8,
            ),
            child: AppButton(
              label: 'ورشاتي المسجلة',
              variant: AppButtonVariant.soft,
              icon: const Icon(Icons.event_available_rounded, size: 20),
              onPressed: controller.openMyWorkshops,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.hasError.value) {
                return _WorkshopError(
                  onRetry: controller.loadWorkshops,
                  onErrorShown: controller.showLoadError,
                );
              }
              if (controller.workshops.isEmpty) {
                return const _EmptyWorkshops();
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
                  return WorkshopCard(
                    workshop: workshop,
                    onPressed: () => controller.openDetails(workshop),
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

class WorkshopCard extends StatelessWidget {
  const WorkshopCard({
    super.key,
    required this.workshop,
    required this.onPressed,
  });

  final WorkshopModel workshop;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      side: const BorderSide(color: AppColors.border),
    );

    return Material(
      color: AppColors.white,
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.12),
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        splashColor: AppColors.lavender,
        highlightColor: AppColors.lavender.withValues(alpha: 0.35),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.softMint,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusField,
                      ),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: AppColors.success,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppDimens.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(workshop.title, style: AppTextStyles.title),
                        const SizedBox(height: AppDimens.space4),
                        const SizedBox(height: AppDimens.space8),
                        Wrap(
                          spacing: AppDimens.space8,
                          runSpacing: AppDimens.space4,
                          children: <Widget>[
                            _WorkshopBadge(
                              label: workshop.ageRange,
                              color: AppColors.lavender,
                              icon: Icons.child_care_rounded,
                            ),
                            _WorkshopBadge(
                              label: 'متبقي ${workshop.remainingSpots} مقاعد',
                              color: AppColors.softYellow,
                              icon: Icons.event_seat_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.space16),
              _WorkshopInfoRow(
                icon: Icons.location_on_outlined,
                text: workshop.location,
              ),
              const SizedBox(height: AppDimens.space8),
              _WorkshopInfoRow(
                icon: Icons.calendar_today_outlined,
                text: workshop.date,
              ),
              const SizedBox(height: AppDimens.space8),
              _WorkshopInfoRow(
                icon: Icons.schedule_outlined,
                text: workshop.time,
              ),
              const SizedBox(height: AppDimens.space8),
              _WorkshopInfoRow(
                icon: Icons.person_outline_rounded,
                text: workshop.supervisor,
              ),
              const SizedBox(height: AppDimens.space16),
              AppButton(
                label: 'عرض الورشة وحجزي',
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
            ],
          ),
        ),
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
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _WorkshopInfoRow extends StatelessWidget {
  const _WorkshopInfoRow({required this.icon, required this.text});

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

class _WorkshopError extends StatelessWidget {
  const _WorkshopError({required this.onRetry, required this.onErrorShown});

  final VoidCallback onRetry;
  final VoidCallback onErrorShown;

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
            const Text(
              'لا يمكن تحميل الورشات الآن',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppDimens.space16),
            AppButton(
              label: 'إعادة المحاولة',
              onPressed: () {
                onErrorShown();
                onRetry();
              },
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWorkshops extends StatelessWidget {
  const _EmptyWorkshops();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.space24),
        child: Text(
          'لا توجد ورشات متاحة حالياً',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

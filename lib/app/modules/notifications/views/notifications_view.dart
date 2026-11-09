import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_orchid.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/notification_card.dart';
import '../../../core/widgets/tab_header.dart';
import '../../../data/models/app_notification.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.coolLavender,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Header Bar with Title, Back Button, and Mark All As Read Action
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.screenHorizontalPadding,
            ),
            child: TabHeader(
              title: 'الإشعارات',
              trailing: AppBackButton(),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppDimens.screenHorizontalPadding,
              end: AppDimens.screenHorizontalPadding,
              bottom: AppDimens.space8,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Obx(
                () => TextButton(
                  onPressed: controller.unreadCount.value > 0
                      ? controller.markAllAsRead
                      : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.space8,
                      vertical: AppDimens.space4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'تعليم الكل كمقروء',
                    style: AppTextStyles.caption.copyWith(
                      color: controller.unreadCount.value > 0
                          ? AppColors.primary
                          : AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppDimens.screenHorizontalPadding,
                    ),
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
                          onPressed: controller.loadNotifications,
                          fullWidth: false,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.notifications.isEmpty) {
                return _buildEmptyState();
              }

              return _buildGroupedList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const AnimatedOrchid(size: 96, autoStart: true),
            const SizedBox(height: AppDimens.space20),
            Text(
              'ما في إشعارات هلق، وردتك بتستناك 🌸',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              'أكمل أنشطتك اليومية الممتعة لتصلك رسائل جديدة!',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSubtitle,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedList() {
    final List<NotificationGroup> groups = controller.groupedNotifications;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppDimens.screenHorizontalPadding,
        AppDimens.space4,
        AppDimens.screenHorizontalPadding,
        AppDimens.space32,
      ),
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int groupIndex) {
        final NotificationGroup group = groups[groupIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: AppDimens.space12,
                bottom: AppDimens.space8,
                start: AppDimens.space4,
              ),
              child: Text(
                group.title,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSubtitle,
                ),
              ),
            ),
            for (final AppNotification item in group.notifications)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.space12),
                child: NotificationCard(
                  notification: item,
                  onTap: () => controller.onNotificationTapped(item),
                ),
              ),
          ],
        );
      },
    );
  }
}

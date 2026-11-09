import 'package:flutter/material.dart';

import '../../data/models/app_notification.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../utils/date_utils.dart';

/// Reusable card displaying an [AppNotification] with category pastel tone,
/// unread purple dot indicator, and relative time.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final AppNotification notification;
  final VoidCallback? onTap;

  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.challenge:
        return AppColors.softYellow;
      case NotificationCategory.rewards:
        return AppColors.softPink;
      case NotificationCategory.workshops:
        return AppColors.softBlue;
      case NotificationCategory.general:
        return AppColors.softMint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    final Color categoryTone = _getCategoryColor(notification.category);

    // Unread items have slightly stronger tone; read items are lighter.
    final Color cardBackground = isUnread
        ? categoryTone.withValues(alpha: 0.7)
        : AppColors.white.withValues(alpha: 0.85);

    final Color borderColor = isUnread
        ? AppColors.primary.withValues(alpha: 0.25)
        : AppColors.border;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.space16),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(
              color: borderColor,
              width: isUnread ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Category Emoji Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusField),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  notification.category.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: AppDimens.space12),

              // Content: Title, Body, Relative Time, Unread Dot
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  notification.title,
                                  style: AppTextStyles.label.copyWith(
                                    fontWeight: isUnread
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isUnread) ...<Widget>[
                                const SizedBox(width: AppDimens.space8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimens.space8),
                        Flexible(
                          child: Text(
                            AppDateUtils.relativeTime(notification.createdAt),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space4),
                    Text(
                      notification.body,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (notification.route != null) ...<Widget>[
                const SizedBox(width: AppDimens.space8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

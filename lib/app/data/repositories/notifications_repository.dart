import '../models/app_notification.dart';

abstract class NotificationsRepository {
  /// Fetches the list of all notifications.
  Future<List<AppNotification>> getNotifications();

  /// Watch count of unread notifications.
  Stream<int> watchUnreadCount();

  /// Get immediate count of unread notifications.
  Future<int> getUnreadCount();

  /// Marks a single notification as read.
  Future<void> markAsRead(String id);

  /// Marks all notifications as read.
  Future<void> markAllAsRead();
}

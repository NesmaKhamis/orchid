import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/app_notification.dart';
import '../../../data/repositories/notifications_repository.dart';

class NotificationGroup {
  const NotificationGroup({
    required this.title,
    required this.notifications,
  });

  final String title;
  final List<AppNotification> notifications;
}

class NotificationsController extends GetxController {
  NotificationsController({required NotificationsRepository repository})
      : _repository = repository;

  final NotificationsRepository _repository;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxInt unreadCount = 0.obs;

  StreamSubscription<int>? _unreadSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToUnreadCount();
    loadNotifications();
  }

  void _subscribeToUnreadCount() {
    _unreadSubscription = _repository.watchUnreadCount().listen(
      (int count) {
        unreadCount.value = count;
      },
      onError: (Object error) {
        Get.log('Error watching unread notifications: $error');
      },
    );
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final List<AppNotification> items =
          await _repository.getNotifications();
      notifications.assignAll(items);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool _isToday(DateTime dt, DateTime now) {
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool _isThisWeek(DateTime dt, DateTime now) {
    if (_isToday(dt, now)) return false;
    final Duration diff = now.difference(dt);
    return diff.inDays < 7 && !diff.isNegative;
  }

  List<NotificationGroup> get groupedNotifications {
    final DateTime now = DateTime.now();
    final List<AppNotification> todayList = <AppNotification>[];
    final List<AppNotification> weekList = <AppNotification>[];
    final List<AppNotification> olderList = <AppNotification>[];

    for (final AppNotification item in notifications) {
      if (_isToday(item.createdAt, now)) {
        todayList.add(item);
      } else if (_isThisWeek(item.createdAt, now)) {
        weekList.add(item);
      } else {
        olderList.add(item);
      }
    }

    final List<NotificationGroup> groups = <NotificationGroup>[];
    if (todayList.isNotEmpty) {
      groups.add(NotificationGroup(title: 'اليوم', notifications: todayList));
    }
    if (weekList.isNotEmpty) {
      groups.add(
        NotificationGroup(title: 'هذا الأسبوع', notifications: weekList),
      );
    }
    if (olderList.isNotEmpty) {
      groups.add(NotificationGroup(title: 'أقدم', notifications: olderList));
    }
    return groups;
  }

  Future<void> onNotificationTapped(AppNotification item) async {
    if (!item.isRead) {
      await markAsRead(item.id);
    }
    if (item.route != null) {
      Get.toNamed(item.route!, arguments: item.arguments);
    }
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    final int index =
        notifications.indexWhere((AppNotification n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
  }

  @override
  void onClose() {
    _unreadSubscription?.cancel();
    super.onClose();
  }
}

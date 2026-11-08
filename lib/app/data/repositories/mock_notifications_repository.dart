import 'dart:async';

import '../../routes/app_routes.dart';
import '../models/app_notification.dart';
import 'notifications_repository.dart';

class MockNotificationsRepository implements NotificationsRepository {
  MockNotificationsRepository() {
    final DateTime now = DateTime.now();
    _notifications = <AppNotification>[
      AppNotification(
        id: 'notif-1',
        category: NotificationCategory.challenge,
        title: 'في تحدي جديد بستناك!',
        body: 'تحدي اليوم بانتظارك لتستمتع وتكسب نقاطاً جديدة.',
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
        route: Routes.drawing,
      ),
      AppNotification(
        id: 'notif-2',
        category: NotificationCategory.rewards,
        title: 'هديتك جاهزة للاستلام!',
        body: 'طلب مكافأتك أصبح جاهزاً للاستلام من مركز الأوركيد.',
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: false,
        route: Routes.myRewardRequests,
      ),
      AppNotification(
        id: 'notif-3',
        category: NotificationCategory.general,
        title: 'كيف قلبك اليوم؟',
        body: 'خذ لحظة لطيفة وسجّل مشاعرك معنا اليوم.',
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: true,
        route: null,
      ),
      AppNotification(
        id: 'notif-4',
        category: NotificationCategory.workshops,
        title: 'ورشة جديدة بانتظارك',
        body: 'ورشة ألوان مشاعري التفاعلية تفتح أبوابها لأصدقائنا الصغار.',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: false,
        route: Routes.workshops,
      ),
      AppNotification(
        id: 'notif-5',
        category: NotificationCategory.rewards,
        title: 'برافو! جمعت ١٠ عملات',
        body: 'أحسنت صنعاً في إكمال نشاط التلوين الموجه اليوم!',
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
        route: Routes.rewards,
      ),
      AppNotification(
        id: 'notif-6',
        category: NotificationCategory.challenge,
        title: 'أبدعت في نشاط الرسم',
        body: 'رسوماتك الجميلة أضافت بهجة لمرسمك الصغير.',
        createdAt: now.subtract(const Duration(days: 4)),
        isRead: true,
        route: Routes.drawing,
      ),
      AppNotification(
        id: 'notif-7',
        category: NotificationCategory.workshops,
        title: 'ورشة نلعب ونتعاون',
        body: 'استعد لمغامرة ممتعة مع أصدقائك في الجمعية.',
        createdAt: now.subtract(const Duration(days: 10)),
        isRead: false,
        route: Routes.workshops,
      ),
      AppNotification(
        id: 'notif-8',
        category: NotificationCategory.general,
        title: 'أهلاً بك في الأوركيد 🌸',
        body: 'نحن سعداء بوجودك معنا في رحلتنا المليئة بالبهجة والإبداع.',
        createdAt: now.subtract(const Duration(days: 14)),
        isRead: true,
        route: null,
      ),
    ];
  }

  late final List<AppNotification> _notifications;
  final StreamController<int> _unreadCountController =
      StreamController<int>.broadcast();

  int get _currentUnreadCount =>
      _notifications.where((AppNotification n) => !n.isRead).length;

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<AppNotification>.unmodifiable(_notifications);
  }

  @override
  Stream<int> watchUnreadCount() async* {
    yield _currentUnreadCount;
    yield* _unreadCountController.stream;
  }

  @override
  Future<int> getUnreadCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _currentUnreadCount;
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final int index =
        _notifications.indexWhere((AppNotification n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _unreadCountController.add(_currentUnreadCount);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        changed = true;
      }
    }
    if (changed) {
      _unreadCountController.add(_currentUnreadCount);
    }
  }
}

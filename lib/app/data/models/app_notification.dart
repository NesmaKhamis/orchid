enum NotificationCategory {
  challenge,
  rewards,
  workshops,
  general,
}

extension NotificationCategoryX on NotificationCategory {
  String get labelArabic {
    switch (this) {
      case NotificationCategory.challenge:
        return 'تحدي';
      case NotificationCategory.rewards:
        return 'مكافآت';
      case NotificationCategory.workshops:
        return 'ورشات';
      case NotificationCategory.general:
        return 'عام';
    }
  }

  String get emoji {
    switch (this) {
      case NotificationCategory.challenge:
        return '⭐';
      case NotificationCategory.rewards:
        return '🎁';
      case NotificationCategory.workshops:
        return '🎨';
      case NotificationCategory.general:
        return '🌸';
    }
  }
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.route,
    this.arguments,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? route;
  final Object? arguments;

  AppNotification copyWith({
    String? id,
    NotificationCategory? category,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? route,
    Object? arguments,
  }) {
    return AppNotification(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      route: route ?? this.route,
      arguments: arguments ?? this.arguments,
    );
  }

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    final dynamic rawDate = map['createdAt'];
    final DateTime date;
    if (rawDate is DateTime) {
      date = rawDate;
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    final String catStr = map['category'] as String? ?? 'general';
    final NotificationCategory category =
        NotificationCategory.values.firstWhere(
      (NotificationCategory e) => e.name == catStr,
      orElse: () => NotificationCategory.general,
    );

    return AppNotification(
      id: id,
      category: category,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      createdAt: date,
      isRead: map['isRead'] as bool? ?? false,
      route: map['route'] as String?,
      arguments: map['arguments'],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'category': category.name,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
    'route': route,
    'arguments': arguments,
  };
}

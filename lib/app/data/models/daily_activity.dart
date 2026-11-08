class DailyActivity {
  const DailyActivity({
    required this.id,
    required this.title,
    required this.coins,
    required this.isCompleted,
    this.route,
  });

  final String id;
  final String title;
  final int coins;
  final bool isCompleted;
  final String? route;

  DailyActivity copyWith({
    String? id,
    String? title,
    int? coins,
    bool? isCompleted,
    String? route,
  }) {
    return DailyActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      coins: coins ?? this.coins,
      isCompleted: isCompleted ?? this.isCompleted,
      route: route ?? this.route,
    );
  }

  factory DailyActivity.fromMap(String id, Map<String, dynamic> map) {
    return DailyActivity(
      id: id,
      title: map['title'] as String? ?? '',
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
      route: map['route'] as String?,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'coins': coins,
    'isCompleted': isCompleted,
    'route': route,
  };
}

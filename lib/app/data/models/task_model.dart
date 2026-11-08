import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.isCompleted,
    required this.dueDate,
    required this.createdAt,
  });

  final String? id;
  final String title;
  final String description;
  final int points;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) => TaskModel(
    id: id,
    title: _requiredString(map, 'title'),
    description: _optionalString(map, 'description'),
    points: _integer(map, 'points'),
    isCompleted: _boolean(map, 'isCompleted'),
    dueDate: _dateTime(map['dueDate'], 'dueDate'),
    createdAt: _dateTime(map['createdAt'], 'createdAt')!,
  );

  Map<String, Object?> toMap() => <String, Object?>{
    'title': title,
    'description': description,
    'points': points,
    'isCompleted': isCompleted,
    'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
    'createdAt': Timestamp.fromDate(createdAt),
  };

  static String _requiredString(Map<String, dynamic> map, String field) {
    final Object? value = map[field];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    throw FormatException('Task document has no valid $field');
  }

  static String _optionalString(Map<String, dynamic> map, String field) {
    final Object? value = map[field];
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }
    throw FormatException('Task document has no valid $field');
  }

  static int _integer(Map<String, dynamic> map, String field) {
    final Object? value = map[field];
    if (value is int) {
      return value;
    }
    throw FormatException('Task document has no valid $field');
  }

  static bool _boolean(Map<String, dynamic> map, String field) {
    final Object? value = map[field];
    if (value is bool) {
      return value;
    }
    throw FormatException('Task document has no valid $field');
  }

  static DateTime? _dateTime(Object? value, String field) {
    if (value == null && field == 'dueDate') {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.parse(value);
    }
    throw FormatException('Task document has no valid $field');
  }
}

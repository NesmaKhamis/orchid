import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_assets.dart';

class ChildModel {
  final String id;
  final String name;
  final String grade;
  final String avatarAsset;
  final String nationalId;
  final DateTime birthDate;

  const ChildModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.avatarAsset,
    required this.nationalId,
    required this.birthDate,
  });

  factory ChildModel.fromMap(String id, Map<String, dynamic> map) {
    final Object? rawBirthDate = map['birthDate'];
    final DateTime birthDate;
    if (rawBirthDate is Timestamp) {
      birthDate = rawBirthDate.toDate();
    } else if (rawBirthDate is DateTime) {
      birthDate = rawBirthDate;
    } else if (rawBirthDate is String) {
      birthDate = DateTime.parse(rawBirthDate);
    } else {
      throw const FormatException('Child document has no valid birthDate');
    }

    return ChildModel(
      id: id,
      name: _requiredString(map, 'name'),
      grade: _optionalString(map, 'grade'),
      avatarAsset: AppAssets.orchidSingle,
      nationalId: _optionalString(map, 'nationalId'),
      birthDate: birthDate,
    );
  }

  Map<String, Object?> toMap() => <String, Object?>{
    'name': name,
    'grade': grade,
    'nationalId': nationalId,
    'birthDate': Timestamp.fromDate(birthDate),
  };

  static String _requiredString(Map<String, dynamic> map, String field) {
    final Object? value = map[field];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    throw FormatException('Child document has no valid $field');
  }

  static String _optionalString(Map<String, dynamic> map, String field) {
    final Object? value = map[field];
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }
    throw FormatException('Child document has no valid $field');
  }
}

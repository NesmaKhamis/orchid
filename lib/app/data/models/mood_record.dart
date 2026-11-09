import 'feeling.dart';

export 'feeling.dart';

/// Represents an emotional check-in record for a child.
class MoodRecord {
  const MoodRecord({
    required this.id,
    this.childId,
    required this.feeling,
    required this.phase,
    this.activityId,
    required this.createdAt,
  });

  final String id;
  final String? childId;
  final Feeling feeling;
  final MoodPhase phase;
  final String? activityId;
  final DateTime createdAt;

  MoodRecord copyWith({
    String? id,
    String? childId,
    Feeling? feeling,
    MoodPhase? phase,
    String? activityId,
    DateTime? createdAt,
  }) {
    return MoodRecord(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      feeling: feeling ?? this.feeling,
      phase: phase ?? this.phase,
      activityId: activityId ?? this.activityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MoodRecord.fromMap(Map<String, dynamic> map, {String? id}) {
    return MoodRecord(
      id: id ?? map['id'] as String? ?? '',
      childId: map['childId'] as String?,
      feeling: FeelingX.fromString(map['feeling'] as String?),
      phase: MoodPhaseX.fromString(map['phase'] as String?),
      activityId: map['activityId'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'childId': childId,
    'feeling': feeling.name,
    'phase': phase.name,
    'activityId': activityId,
    'createdAt': createdAt.toIso8601String(),
  };
}

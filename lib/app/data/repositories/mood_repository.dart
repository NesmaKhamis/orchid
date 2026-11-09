import '../models/mood_record.dart';

/// Abstract repository managing child mood check-in records.
abstract class MoodRepository {
  /// Saves a mood check-in record.
  Future<MoodRecord> saveRecord(MoodRecord record);

  /// Returns today's last recorded mood for [childId].
  Future<MoodRecord?> getTodayLastRecord({String? childId});

  /// Real-time stream of today's last recorded mood for [childId].
  Stream<MoodRecord?> watchTodayLastRecord({String? childId});
}

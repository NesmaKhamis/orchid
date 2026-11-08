import 'dart:async';

import '../models/mood_record.dart';
import 'mood_repository.dart';

/// In-memory mock implementation of [MoodRepository].
class MockMoodRepository implements MoodRepository {
  MockMoodRepository({List<MoodRecord>? initialRecords})
      : _records = initialRecords ?? <MoodRecord>[];

  final List<MoodRecord> _records;
  final StreamController<MoodRecord?> _todayLastRecordController =
      StreamController<MoodRecord?>.broadcast();

  bool _isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Future<MoodRecord> saveRecord(MoodRecord record) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final MoodRecord saved = record.id.isEmpty
        ? record.copyWith(id: 'mood-${DateTime.now().millisecondsSinceEpoch}')
        : record;
    _records.add(saved);
    _todayLastRecordController.add(saved);
    return saved;
  }

  @override
  Future<MoodRecord?> getTodayLastRecord({String? childId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    for (int i = _records.length - 1; i >= 0; i--) {
      final MoodRecord record = _records[i];
      if (!_isToday(record.createdAt)) {
        continue;
      }
      if (childId == null || record.childId == null || record.childId == childId) {
        return record;
      }
    }
    return null;
  }

  @override
  Stream<MoodRecord?> watchTodayLastRecord({String? childId}) async* {
    yield await getTodayLastRecord(childId: childId);
    yield* _todayLastRecordController.stream.where((MoodRecord? record) {
      if (record == null) {
        return true;
      }
      if (!_isToday(record.createdAt)) {
        return false;
      }
      if (childId == null || record.childId == null) {
        return true;
      }
      return record.childId == childId;
    });
  }
}

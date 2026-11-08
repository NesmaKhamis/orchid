import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orchid_app/app/data/models/child_model.dart';
import 'package:orchid_app/app/data/models/task_model.dart';
import 'package:orchid_app/app/data/repositories/mock_tasks_repository.dart';

void main() {
  test('child model reads Firestore document data', () {
    final ChildModel child = ChildModel.fromMap('child-1', <String, dynamic>{
      'name': 'مريم',
      'grade': 'الصف الأول',
      'nationalId': '1234567890',
      'birthDate': Timestamp.fromDate(DateTime(2018, 5, 14)),
    });

    expect(child.id, 'child-1');
    expect(child.name, 'مريم');
    expect(child.birthDate, DateTime(2018, 5, 14));
  });

  test('task model serializes Firestore fields without its document id', () {
    final DateTime createdAt = DateTime(2026, 11, 8, 11, 0);
    final TaskModel task = TaskModel(
      id: 'task-1',
      title: 'ترتيب الغرفة',
      description: 'ترتيب الألعاب',
      points: 10,
      isCompleted: false,
      dueDate: null,
      createdAt: createdAt,
    );

    final Map<String, Object?> map = task.toMap();
    final TaskModel restored = TaskModel.fromMap(
      'task-1',
      Map<String, dynamic>.from(map),
    );

    expect(map.containsKey('id'), isFalse);
    expect(restored.id, 'task-1');
    expect(restored.title, task.title);
    expect(restored.points, task.points);
    expect(restored.createdAt, createdAt);
  });

  test('mock task repository supports child-scoped task operations', () async {
    final MockTasksRepository repository = MockTasksRepository();
    final String taskId = await repository.addTask(
      'child-1',
      TaskModel(
        title: 'ترتيب الغرفة',
        description: '',
        points: 10,
        isCompleted: false,
        dueDate: null,
        createdAt: DateTime(2026, 11, 8),
      ),
    );

    expect((await repository.getTasks('child-1')).single.id, taskId);
    expect(await repository.getTasks('child-2'), isEmpty);

    await repository.deleteTask('child-1', taskId);
    expect(await repository.getTasks('child-1'), isEmpty);
  });
}

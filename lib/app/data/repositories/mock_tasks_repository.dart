import '../models/task_model.dart';
import 'tasks_repository.dart';

class MockTasksRepository implements TasksRepository {
  final Map<String, Map<String, TaskModel>> _tasksByChild =
      <String, Map<String, TaskModel>>{};
  int _nextId = 0;

  @override
  Future<List<TaskModel>> getTasks(String childId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List<TaskModel>.unmodifiable(
      _tasksByChild[childId]?.values ?? const <TaskModel>[],
    );
  }

  @override
  Future<String> addTask(String childId, TaskModel task) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final String id = 'mock-task-${++_nextId}';
    _tasksByChild.putIfAbsent(childId, () => <String, TaskModel>{})[id] =
        TaskModel(
          id: id,
          title: task.title,
          description: task.description,
          points: task.points,
          isCompleted: task.isCompleted,
          dueDate: task.dueDate,
          createdAt: task.createdAt,
        );
    return id;
  }

  @override
  Future<void> updateTask(String childId, TaskModel task) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final String? id = task.id;
    if (id == null || !_tasksByChild.containsKey(childId)) {
      throw StateError('Cannot update a task without a child and task id');
    }
    _tasksByChild[childId]![id] = task;
  }

  @override
  Future<void> deleteTask(String childId, String taskId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _tasksByChild[childId]?.remove(taskId);
  }
}

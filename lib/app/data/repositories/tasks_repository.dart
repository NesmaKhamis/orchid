import '../models/task_model.dart';

abstract class TasksRepository {
  Future<List<TaskModel>> getTasks(String childId);

  Future<String> addTask(String childId, TaskModel task);

  Future<void> updateTask(String childId, TaskModel task);

  Future<void> deleteTask(String childId, String taskId);
}

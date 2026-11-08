import 'package:get/get.dart';

import '../../../data/repositories/firebase_tasks_repository.dart';
import '../../../data/repositories/tasks_repository.dart';

class TasksBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TasksRepository>()) {
      Get.lazyPut<TasksRepository>(() => FirebaseTasksRepository());
    }
  }
}

import 'package:get/get.dart';

import '../../../data/repositories/mock_workshops_repository.dart';
import '../../../data/repositories/workshops_repository.dart';
import '../controllers/my_workshops_controller.dart';

class MyWorkshopsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WorkshopsRepository>()) {
      Get.lazyPut<WorkshopsRepository>(
        () => MockWorkshopsRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<MyWorkshopsController>(
      () => MyWorkshopsController(repository: Get.find<WorkshopsRepository>()),
    );
  }
}

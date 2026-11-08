import 'package:get/get.dart';

import '../../../data/repositories/mock_workshops_repository.dart';
import '../../../data/repositories/workshops_repository.dart';
import '../controllers/workshop_list_controller.dart';

class WorkshopsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WorkshopsRepository>()) {
      Get.lazyPut<WorkshopsRepository>(
        () => MockWorkshopsRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<WorkshopListController>(
      () => WorkshopListController(repository: Get.find<WorkshopsRepository>()),
    );
  }
}

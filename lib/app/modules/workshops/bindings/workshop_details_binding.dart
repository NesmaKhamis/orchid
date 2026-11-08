import 'package:get/get.dart';

import '../../../data/models/workshop_model.dart';
import '../../../data/repositories/workshops_repository.dart';
import '../controllers/workshop_details_controller.dart';

class WorkshopDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkshopDetailsController>(() {
      final arguments = Get.arguments;
      if (arguments == null) {
        throw StateError('A workshop is required to open workshop details');
      }
      return WorkshopDetailsController(
        repository: Get.find<WorkshopsRepository>(),
        workshop: arguments as WorkshopModel,
      );
    });
  }
}

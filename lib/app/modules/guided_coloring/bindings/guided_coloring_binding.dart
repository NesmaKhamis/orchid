import 'package:get/get.dart';

import '../../../data/repositories/coloring_repository.dart';
import '../../../data/repositories/mock_coloring_repository.dart';
import '../controllers/guided_coloring_controller.dart';

class GuidedColoringBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ColoringRepository>(() => MockColoringRepository(),
        fenix: true);
    Get.lazyPut<GuidedColoringController>(
      () => GuidedColoringController(
        repository: Get.find<ColoringRepository>(),
      ),
      fenix: true,
    );
  }
}

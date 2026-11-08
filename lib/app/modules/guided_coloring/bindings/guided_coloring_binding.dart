import 'package:get/get.dart';

import '../../../data/repositories/coloring_repository.dart';
import '../../../data/repositories/mock_coloring_repository.dart';
import '../../../data/repositories/mock_mood_repository.dart';
import '../../../data/repositories/mood_repository.dart';
import '../controllers/guided_coloring_controller.dart';

class GuidedColoringBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MoodRepository>()) {
      Get.lazyPut<MoodRepository>(() => MockMoodRepository(), fenix: true);
    }
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

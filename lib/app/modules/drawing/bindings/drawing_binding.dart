import 'package:get/get.dart';

import '../../../data/repositories/mock_mood_repository.dart';
import '../../../data/repositories/mood_repository.dart';
import '../controllers/drawing_controller.dart';

class DrawingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MoodRepository>()) {
      Get.lazyPut<MoodRepository>(() => MockMoodRepository(), fenix: true);
    }
    Get.lazyPut<DrawingController>(() => DrawingController());
  }
}

import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/repositories/mock_mood_repository.dart';
import '../../../data/repositories/mock_rewards_repository.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../controllers/feelings_controller.dart';

class FeelingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MoodRepository>()) {
      Get.lazyPut<MoodRepository>(() => MockMoodRepository(), fenix: true);
    }
    if (!Get.isRegistered<RewardsRepository>()) {
      Get.lazyPut<RewardsRepository>(() => MockRewardsRepository(), fenix: true);
    }

    Get.lazyPut<FeelingsController>(
      () => FeelingsController(
        moodRepository: Get.find<MoodRepository>(),
        rewardsRepository: Get.find<RewardsRepository>(),
        sessionService:
            Get.isRegistered<SessionService>() ? Get.find<SessionService>() : null,
      ),
    );
  }
}

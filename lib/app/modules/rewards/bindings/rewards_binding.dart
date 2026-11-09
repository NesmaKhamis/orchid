import 'package:get/get.dart';

import '../../../data/repositories/mock_rewards_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../controllers/rewards_controller.dart';

class RewardsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<RewardsRepository>()) {
      Get.lazyPut<RewardsRepository>(
        () => MockRewardsRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<RewardsController>(
      () => RewardsController(repository: Get.find<RewardsRepository>()),
      fenix: true,
    );
  }
}

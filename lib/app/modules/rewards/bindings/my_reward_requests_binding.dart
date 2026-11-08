import 'package:get/get.dart';

import '../../../data/repositories/mock_rewards_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../controllers/my_reward_requests_controller.dart';

class MyRewardRequestsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<RewardsRepository>()) {
      Get.lazyPut<RewardsRepository>(
        () => MockRewardsRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<MyRewardRequestsController>(
      () => MyRewardRequestsController(
        repository: Get.find<RewardsRepository>(),
      ),
    );
  }
}

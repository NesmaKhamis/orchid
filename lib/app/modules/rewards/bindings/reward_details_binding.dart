import 'package:get/get.dart';

import '../../../data/models/reward_item.dart';
import '../../../data/repositories/mock_rewards_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../controllers/reward_details_controller.dart';

class RewardDetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<RewardsRepository>()) {
      Get.lazyPut<RewardsRepository>(
        () => MockRewardsRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<RewardDetailsController>(() {
      final Object? arguments = Get.arguments;
      if (arguments is! RewardItem) {
        throw StateError('A RewardItem is required to open reward details');
      }
      return RewardDetailsController(
        repository: Get.find<RewardsRepository>(),
        reward: arguments,
      );
    });
  }
}

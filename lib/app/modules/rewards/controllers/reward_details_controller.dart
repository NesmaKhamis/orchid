import 'package:get/get.dart';

import '../../../data/models/reward_item.dart';
import '../../../data/models/reward_request.dart';
import '../../../data/repositories/rewards_repository.dart';

class RewardDetailsController extends GetxController {
  RewardDetailsController({
    required RewardsRepository repository,
    required this.reward,
  }) : _repository = repository;

  final RewardsRepository _repository;
  final RewardItem reward;

  final RxInt balance = 0.obs;
  final RxBool isRedeeming = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    balance.value = await _repository.getBalance();
  }

  bool get isOutOfStock => reward.isOutOfStock;
  bool get hasEnoughCoins => balance.value >= reward.cost;
  int get missingCoins => hasEnoughCoins ? 0 : (reward.cost - balance.value);
  bool get canRedeem => !isOutOfStock && hasEnoughCoins;

  Future<RewardRequest> redeem() async {
    isRedeeming.value = true;
    try {
      final RewardRequest request = await _repository.redeem(reward.id);
      balance.value = await _repository.getBalance();
      return request;
    } finally {
      isRedeeming.value = false;
    }
  }
}

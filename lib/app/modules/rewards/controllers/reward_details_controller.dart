import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
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

  Future<RewardRequest?> redeem() async {
    isRedeeming.value = true;
    try {
      final RewardRequest request = await _repository.redeem(reward.id);
      balance.value = await _repository.getBalance();
      AppSnackbar.success('تم إرسال طلبك بنجاح وهو الآن قيد المراجعة!');
      return request;
    } on RewardsFailure catch (failure) {
      AppSnackbar.error(failure.message);
      return null;
    } catch (error) {
      AppSnackbar.error('حدث خطأ أثناء إتمام الطلب، يرجى المحاولة لاحقاً');
      return null;
    } finally {
      isRedeeming.value = false;
    }
  }
}

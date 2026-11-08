import 'dart:async';

import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/daily_activity.dart';
import '../../../data/models/reward_item.dart';
import '../../../data/models/reward_request.dart';
import '../../../data/repositories/rewards_repository.dart';

enum RewardCardState {
  available,
  notEnoughCoins,
  outOfStock,
}

class RewardsController extends GetxController {
  RewardsController({required RewardsRepository repository})
      : _repository = repository;

  final RewardsRepository _repository;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt balance = 0.obs;
  final RxInt todayEarned = 0.obs;
  final RxList<DailyActivity> dailyActivities = <DailyActivity>[].obs;
  final RxList<RewardItem> rewards = <RewardItem>[].obs;
  final RxList<RewardRequest> requests = <RewardRequest>[].obs;

  StreamSubscription<int>? _balanceSubscription;

  int get dailyCap => AppConstants.dailyCoinCap;

  double get todayProgress {
    if (dailyCap <= 0) return 0.0;
    return (todayEarned.value / dailyCap).clamp(0.0, 1.0);
  }

  bool isOutOfStock(RewardItem item) => item.isOutOfStock;

  bool hasEnoughCoins(RewardItem item) => balance.value >= item.cost;

  int missingCoinsFor(RewardItem item) {
    if (hasEnoughCoins(item)) return 0;
    return item.cost - balance.value;
  }

  RewardCardState getCardState(RewardItem item) {
    if (isOutOfStock(item)) {
      return RewardCardState.outOfStock;
    }
    if (!hasEnoughCoins(item)) {
      return RewardCardState.notEnoughCoins;
    }
    return RewardCardState.available;
  }

  @override
  void onInit() {
    super.onInit();
    _subscribeToBalance();
    loadRewardsData();
  }

  void _subscribeToBalance() {
    _balanceSubscription = _repository.watchBalance().listen(
      (int currentBalance) {
        balance.value = currentBalance;
      },
      onError: (Object error) {
        Get.log('Error watching balance: $error');
      },
    );
  }

  Future<void> loadRewardsData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final List<dynamic> results =
          await Future.wait<dynamic>(<Future<dynamic>>[
        _repository.getBalance(),
        _repository.getTodayEarnedCoins(),
        _repository.getDailyActivities(),
        _repository.getRewards(),
        _repository.getRequests(),
      ]);

      balance.value = results[0] as int;
      todayEarned.value = results[1] as int;
      dailyActivities.assignAll(results[2] as List<DailyActivity>);
      rewards.assignAll(results[3] as List<RewardItem>);
      requests.assignAll(results[4] as List<RewardRequest>);
    } on Object catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<RewardRequest> redeemReward(RewardItem item) async {
    try {
      final RewardRequest request = await _repository.redeem(item.id);
      final List<RewardItem> updatedRewards = await _repository.getRewards();
      final List<RewardRequest> updatedRequests =
          await _repository.getRequests();
      rewards.assignAll(updatedRewards);
      requests.assignAll(updatedRequests);
      return request;
    } catch (error) {
      rethrow;
    }
  }

  @override
  void onClose() {
    _balanceSubscription?.cancel();
    super.onClose();
  }
}

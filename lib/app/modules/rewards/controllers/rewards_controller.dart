import 'dart:async';

import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';
import '../../../data/models/daily_activity.dart';
import '../../../data/models/mood_record.dart';
import '../../../data/models/reward_item.dart';
import '../../../data/models/reward_request.dart';
import '../../../data/repositories/mood_repository.dart';
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
  final RxInt selectedTab = 0.obs;
  final RxInt balance = 0.obs;
  final RxInt todayEarned = 0.obs;
  final RxList<DailyActivity> dailyActivities = <DailyActivity>[].obs;
  final RxList<RewardItem> rewards = <RewardItem>[].obs;
  final RxList<RewardRequest> requests = <RewardRequest>[].obs;

  StreamSubscription<int>? _balanceSubscription;
  StreamSubscription<MoodRecord?>? _moodSubscription;

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
    _subscribeToMoodRecord();
    loadRewardsData();
  }

  void _subscribeToMoodRecord() {
    if (Get.isRegistered<MoodRepository>()) {
      final String? childId = Get.isRegistered<SessionService>()
          ? Get.find<SessionService>().selectedChildId
          : null;
      _moodSubscription = Get.find<MoodRepository>()
          .watchTodayLastRecord(childId: childId)
          .listen((MoodRecord? record) async {
        if (record != null) {
          final int index =
              dailyActivities.indexWhere((DailyActivity a) => a.id == 'act-mood');
          if (index != -1 && !dailyActivities[index].isCompleted) {
            dailyActivities[index] =
                dailyActivities[index].copyWith(isCompleted: true, route: null);
          }
          todayEarned.value = await _repository.getTodayEarnedCoins();
        }
      });
    }
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
      final List<DailyActivity> loadedActivities =
          results[2] as List<DailyActivity>;

      if (Get.isRegistered<MoodRepository>()) {
        final String? childId = Get.isRegistered<SessionService>()
            ? Get.find<SessionService>().selectedChildId
            : null;
        final MoodRecord? record = await Get.find<MoodRepository>()
            .getTodayLastRecord(childId: childId);
        if (record != null) {
          final int index =
              loadedActivities.indexWhere((DailyActivity a) => a.id == 'act-mood');
          if (index != -1) {
            loadedActivities[index] =
                loadedActivities[index].copyWith(isCompleted: true, route: null);
          }
        }
      }

      dailyActivities.assignAll(loadedActivities);
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
    _moodSubscription?.cancel();
    super.onClose();
  }
}

import '../models/daily_activity.dart';
import '../models/reward_item.dart';
import '../models/reward_request.dart';

/// Failure thrown when a reward operation cannot be completed.
class RewardsFailure implements Exception {
  const RewardsFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract class RewardsRepository {
  /// Fetches the child's current coin balance.
  Future<int> getBalance();

  /// Reactive stream of coin balance changes.
  Stream<int> watchBalance();

  /// Coins earned today by the child towards the daily cap.
  Future<int> getTodayEarnedCoins();

  /// List of today's activities with completion status and routes.
  Future<List<DailyActivity>> getDailyActivities();

  /// List of available rewards from the charity.
  Future<List<RewardItem>> getRewards();

  /// Fetch single reward by id.
  Future<RewardItem?> getRewardById(String id);

  /// Redemption requests for the child.
  Future<List<RewardRequest>> getRequests();

  /// Redeems a reward, creating a request and deducting coins.
  Future<RewardRequest> redeem(String rewardId);

  /// Completes a daily activity by [activityId], awarding coins up to the daily cap.
  /// Returns the actual coins awarded (0 if already completed or capped).
  Future<int> completeActivity(String activityId);
}

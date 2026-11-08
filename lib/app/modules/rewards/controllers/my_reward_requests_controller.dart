import 'package:get/get.dart';

import '../../../data/models/reward_request.dart';
import '../../../data/repositories/rewards_repository.dart';

class MyRewardRequestsController extends GetxController {
  MyRewardRequestsController({required RewardsRepository repository})
      : _repository = repository;

  final RewardsRepository _repository;

  final RxBool isLoading = true.obs;
  final RxList<RewardRequest> requests = <RewardRequest>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final List<RewardRequest> result = await _repository.getRequests();
      requests.assignAll(result);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

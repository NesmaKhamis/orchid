import 'package:get/get.dart';

import '../../../data/repositories/mock_profile_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(() => MockProfileRepository());
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<ProfileRepository>()),
    );
  }
}

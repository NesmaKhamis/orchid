import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../data/repositories/firebase_children_repository.dart';
import '../../../data/repositories/firebase_profile_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChildrenRepository>()) {
      Get.lazyPut<ChildrenRepository>(() => FirebaseChildrenRepository());
    }
    Get.lazyPut<ProfileRepository>(
      () => FirebaseProfileRepository(
        childId: Get.find<SessionService>().selectedChildId,
      ),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<ProfileRepository>(),
        Get.find<SessionService>(),
        Get.find<ChildrenRepository>(),
      ),
    );
  }
}

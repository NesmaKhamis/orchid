import 'package:get/get.dart';

<<<<<<< HEAD
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
=======
class ProfileBinding extends Bindings {
  @override
  void dependencies() {}
>>>>>>> 9b01b038e93a01f4ef6d11ec465397272b4be6f7
}

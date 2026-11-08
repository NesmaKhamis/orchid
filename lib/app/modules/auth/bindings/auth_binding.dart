import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // InitialBinding normally provides the shared repository used by sessions.
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository());
    }
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

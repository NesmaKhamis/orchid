import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Swapping the auth backend happens here and nowhere else.
    Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository());
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}

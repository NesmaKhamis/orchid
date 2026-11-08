import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository());
    }
    Get.lazyPut<EmailVerificationController>(
      () => EmailVerificationController(),
    );
  }
}

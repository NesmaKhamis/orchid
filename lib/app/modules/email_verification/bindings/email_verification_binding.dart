import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/mock_auth_repository.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => MockAuthRepository());
    Get.lazyPut<EmailVerificationController>(
      () => EmailVerificationController(),
    );
  }
}

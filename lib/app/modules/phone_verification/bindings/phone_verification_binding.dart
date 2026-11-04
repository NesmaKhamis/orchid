import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/mock_auth_repository.dart';
import '../controllers/phone_verification_controller.dart';

class PhoneVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => MockAuthRepository());
    Get.lazyPut<PhoneVerificationController>(
      () => PhoneVerificationController(),
    );
  }
}

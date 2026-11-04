import 'package:get/get.dart';

import '../controllers/verification_rejected_controller.dart';

class VerificationRejectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationRejectedController>(
      () => VerificationRejectedController(),
    );
  }
}

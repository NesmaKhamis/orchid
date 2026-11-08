import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class PrivacyController extends GetxController {
  final consentGiven = false.obs;

  @override
  void onReady() {
    super.onReady();
    Get.find<SessionService>().saveStep(Routes.privacy);
  }

  bool get canContinue => consentGiven.value;

  void setConsent(bool value) {
    consentGiven.value = value;
  }

  void proceedToPhoneVerification() {
    if (!canContinue) return;
    Get.toNamed(Routes.phoneVerification);
  }

  void readPrivacyPolicy() {
    AppSnackbar.info('قريباً');
  }
}

import 'dart:async';

import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';

class SplashController extends GetxController {
  Timer? _navigationTimer;

  @override
  void onReady() {
    super.onReady();
    _navigationTimer = Timer(AppConstants.splashMinDuration, () {
      if (!isClosed) {
        Get.offNamed(Get.find<SessionService>().resolveStartRoute());
      }
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    super.onClose();
  }
}

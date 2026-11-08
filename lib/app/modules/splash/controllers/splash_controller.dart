import 'dart:async';

import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';

class SplashController extends GetxController {
  Timer? _navigationTimer;

  @override
  void onReady() {
    super.onReady();
    _navigationTimer = Timer(AppConstants.splashMinDuration, _navigate);
  }

  Future<void> _navigate() async {
    final String route = await Get.find<SessionService>().resolveStartRoute();
    if (!isClosed) {
      Get.offNamed(route);
    }
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    super.onClose();
  }
}

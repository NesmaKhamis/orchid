import 'dart:async';

import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';

class SplashController extends GetxController {
  final isWinking = false.obs;
  Timer? _winkTimer;
  Timer? _navigationTimer;

  @override
  void onReady() {
    super.onReady();
    _startWinkAnimation();
    _navigationTimer = Timer(AppConstants.splashMinDuration, () {
      if (!isClosed) {
        Get.offNamed(Get.find<SessionService>().resolveStartRoute());
      }
    });
  }

  void _startWinkAnimation() {
    _winkTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (isClosed) return;
      isWinking.value = true;

      await Future.delayed(const Duration(milliseconds: 350));

      if (!isClosed) {
        isWinking.value = false;
      }
    });
  }

  @override
  void onClose() {
    _winkTimer?.cancel();
    _navigationTimer?.cancel();
    super.onClose();
  }
}

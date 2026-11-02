import 'dart:async';

import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final isWinking = false.obs;
  Timer? _winkTimer;
  Timer? _navigationTimer;

  @override
  void onReady() {
    super.onReady();
    _startWinkAnimation();
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!isClosed) {
        Get.offNamed(Routes.onboarding);
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

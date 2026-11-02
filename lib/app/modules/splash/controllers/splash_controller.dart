import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // الانتقال لشاشة الترحيب بعد 3 ثوانٍ بالضبط
    Future.delayed(const Duration(seconds: 10), () {
      Get.offNamed(Routes.ONBOARDING);
    });
  }
}
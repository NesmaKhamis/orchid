import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  // دالة للانتقال لشاشة تسجيل الدخول عند الضغط على زر "هيا لنبدأ الرحلة"
  void startJourney() {
    Get.offNamed(Routes.LOGIN);
  }
}
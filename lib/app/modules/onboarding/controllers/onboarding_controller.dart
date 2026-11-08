import 'package:get/get.dart';
import '../../../core/services/session_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  // دالة للانتقال لشاشة تسجيل الدخول عند الضغط على زر "هيا لنبدأ الرحلة"
  Future<void> startJourney() async {
    await Get.find<SessionService>().markOnboardingSeen();
    Get.offNamed(Routes.login);
  }
}

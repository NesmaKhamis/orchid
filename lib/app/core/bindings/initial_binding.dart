import 'package:get/get.dart';

import '../services/local_session_storage.dart';
import '../services/session_service.dart';
import '../services/session_storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SessionStorage>()) {
      Get.put<SessionStorage>(LocalSessionStorage(), permanent: true);
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(
        SessionService(Get.find<SessionStorage>()),
        permanent: true,
      );
    }
  }
}

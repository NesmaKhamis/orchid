import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../services/firebase_session_storage.dart';
import '../services/local_session_storage.dart';
import '../services/session_service.dart';
import '../services/session_storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(FirebaseAuthRepository(), permanent: true);
    }

    if (!Get.isRegistered<SessionStorage>()) {
      Get.put<SessionStorage>(
        FirebaseSessionStorage(localStorage: LocalSessionStorage()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(
        SessionService(Get.find<SessionStorage>(), Get.find<AuthRepository>()),
        permanent: true,
      );
    }
  }
}

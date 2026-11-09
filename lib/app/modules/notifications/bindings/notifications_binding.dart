import 'package:get/get.dart';

import '../../../data/repositories/mock_notifications_repository.dart';
import '../../../data/repositories/notifications_repository.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsRepository>()) {
      Get.lazyPut<NotificationsRepository>(
        () => MockNotificationsRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        repository: Get.find<NotificationsRepository>(),
      ),
    );
  }
}

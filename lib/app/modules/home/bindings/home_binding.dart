import 'package:get/get.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../data/repositories/firebase_children_repository.dart';
import '../../../data/repositories/mock_mood_repository.dart';
import '../../../data/repositories/mock_notifications_repository.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../data/repositories/notifications_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChildrenRepository>()) {
      Get.lazyPut<ChildrenRepository>(() => FirebaseChildrenRepository());
    }
    if (!Get.isRegistered<NotificationsRepository>()) {
      Get.lazyPut<NotificationsRepository>(
        () => MockNotificationsRepository(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<MoodRepository>()) {
      Get.lazyPut<MoodRepository>(
        () => MockMoodRepository(),
        fenix: true,
      );
    }
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

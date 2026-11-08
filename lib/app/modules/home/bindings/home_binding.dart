import 'package:get/get.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../data/repositories/firebase_children_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChildrenRepository>()) {
      Get.lazyPut<ChildrenRepository>(() => FirebaseChildrenRepository());
    }
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

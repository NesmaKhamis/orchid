import 'package:get/get.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../data/repositories/mock_child_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChildRepository>()) {
      Get.lazyPut<ChildRepository>(() => MockChildRepository());
    }
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

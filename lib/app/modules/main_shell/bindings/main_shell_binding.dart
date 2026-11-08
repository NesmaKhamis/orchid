import 'package:get/get.dart';

import '../../home/bindings/home_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../controllers/main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    ProfileBinding().dependencies();
    Get.lazyPut<MainShellController>(() => MainShellController());
  }
}

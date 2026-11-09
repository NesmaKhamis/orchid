import 'package:get/get.dart';

import '../../home/bindings/home_binding.dart';
import '../../rewards/bindings/rewards_binding.dart';
import '../controllers/main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    RewardsBinding().dependencies();
    Get.lazyPut<MainShellController>(() => MainShellController());
  }
}

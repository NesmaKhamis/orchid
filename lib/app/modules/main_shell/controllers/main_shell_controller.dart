import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../rewards/controllers/rewards_controller.dart';

class MainShellController extends GetxController {
  static const int homeTabIndex = 0;
  static const int rewardsTabIndex = 1;
  static const int profileTabIndex = 2;

  final selectedIndex = 0.obs;

  void selectTab(int index) {
    if (index < 0 || index > 2) {
      return;
    }
    selectedIndex.value = index;
  }

  void changeTab(int index) => selectTab(index);

  /// Navigates back to the main shell if currently on a pushed screen,
  /// selects the Rewards tab (index 1), and activates the "طلباتي" requests
  /// inner tab (index 2).
  static void openRewardsRequests({int innerTab = 2}) {
    if (Get.currentRoute != Routes.home) {
      Get.until((route) => route.settings.name == Routes.home || route.isFirst);
      if (Get.currentRoute != Routes.home) {
        Get.offAllNamed(Routes.home);
      }
    }
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().changeTab(rewardsTabIndex);
    }
    if (Get.isRegistered<RewardsController>()) {
      final RewardsController controller = Get.find<RewardsController>();
      controller.selectedTab.value = innerTab;
      controller.loadRewardsData();
    }
  }
}

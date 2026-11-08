import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../rewards/views/rewards_view.dart';
import '../controllers/main_shell_controller.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  static const List<AppBottomNavItem> _tabs = <AppBottomNavItem>[
    AppBottomNavItem(
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    AppBottomNavItem(
      label: 'المكافآت والهدايا',
      icon: Icons.card_giftcard_outlined,
      activeIcon: Icons.card_giftcard_rounded,
    ),
    AppBottomNavItem(
      label: 'الملف الشخصي',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        backgroundColor: AppColors.coolLavender,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const <Widget>[
            HomeView(),
            RewardsContent(),
            ProfileContent(),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          items: _tabs,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.selectTab,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../rewards/views/rewards_view.dart';
import '../controllers/main_shell_controller.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  static const List<_ShellTab> _tabs = <_ShellTab>[
    _ShellTab(
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _ShellTab(
      label: 'المكافآت والهدايا',
      icon: Icons.card_giftcard_outlined,
      selectedIcon: Icons.card_giftcard_rounded,
    ),
    _ShellTab(
      label: 'الملف الشخصي',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const <Widget>[
            HomeView(),
            RewardsContent(),
            ProfileContent(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.selectTab,
          backgroundColor: AppColors.white,
          indicatorColor: AppColors.lavender,
          height: 76,
          labelTextStyle: const WidgetStatePropertyAll<TextStyle>(
            AppTextStyles.caption,
          ),
          destinations: <NavigationDestination>[
            for (int index = 0; index < _tabs.length; index++)
              NavigationDestination(
                icon: Icon(_tabs[index].icon),
                selectedIcon: Icon(_tabs[index].selectedIcon),
                label: _tabs[index].label,
              ),
          ],
        ),
      ),
    );
  }
}

class _ShellTab {
  const _ShellTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

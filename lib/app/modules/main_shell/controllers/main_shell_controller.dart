import 'package:get/get.dart';

class MainShellController extends GetxController {
  final selectedIndex = 0.obs;

  void selectTab(int index) {
    if (index < 0 || index > 2) {
      return;
    }
    selectedIndex.value = index;
  }
}

import 'package:get/get.dart';
import '../controllers/child_details_controller.dart';

class ChildDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildDetailsController>(
      () => ChildDetailsController(),
    );
  }
}

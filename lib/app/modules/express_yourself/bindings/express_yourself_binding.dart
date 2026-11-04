import 'package:get/get.dart';

import '../controllers/express_yourself_controller.dart';

class ExpressYourselfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpressYourselfController>(
      () => ExpressYourselfController(),
    );
  }
}

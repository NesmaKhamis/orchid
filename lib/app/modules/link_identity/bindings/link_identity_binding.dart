import 'package:get/get.dart';
import '../controllers/link_identity_controller.dart';

class LinkIdentityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LinkIdentityController>(
      () => LinkIdentityController(),
    );
  }
}

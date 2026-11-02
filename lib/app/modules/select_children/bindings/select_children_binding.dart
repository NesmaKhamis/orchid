import 'package:get/get.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../data/repositories/mock_child_repository.dart';
import '../controllers/select_children_controller.dart';

class SelectChildrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildRepository>(() => MockChildRepository());
    Get.lazyPut<SelectChildrenController>(
      () => SelectChildrenController(),
    );
  }
}

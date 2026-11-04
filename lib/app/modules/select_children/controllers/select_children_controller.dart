import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../routes/app_routes.dart';

class SelectChildrenController extends GetxController {
  final ChildRepository _repository = Get.find<ChildRepository>();

  final childrenList = <ChildModel>[].obs;
  final selectedChildId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadChildrenData();
  }

  Future<void> loadChildrenData() async {
    final children = await _repository.getChildren();
    childrenList.assignAll(children);

    if (childrenList.isNotEmpty) {
      selectedChildId.value = childrenList.first.id;
    }
  }

  void selectChild(String id) {
    selectedChildId.value = id;
  }

  void proceedToChildDetails() {
    final selectedChild =
        childrenList.firstWhere((c) => c.id == selectedChildId.value);

    final age = AppDateUtils.ageFrom(selectedChild.birthDate);
    final isEligible =
        age >= AppConstants.minChildAge && age <= AppConstants.maxChildAge;

    if (isEligible) {
      Get.toNamed(Routes.childDetails, arguments: selectedChild);
    } else {
      Get.toNamed(Routes.verificationRejected, arguments: selectedChild);
    }
  }
}

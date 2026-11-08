import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../routes/app_routes.dart';

class SelectChildrenController extends GetxController {
  final ChildrenRepository _repository = Get.find<ChildrenRepository>();

  final childrenList = <ChildModel>[].obs;
  final selectedChildId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadChildrenData();
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<SessionService>().saveStep(Routes.selectChildren);
  }

  Future<void> loadChildrenData() async {
    try {
      final children = await _repository.getChildren();
      if (isClosed) return;
      childrenList.assignAll(children);

      if (childrenList.isNotEmpty) {
        final String? savedChildId =
            Get.find<SessionService>().selectedChildId;
        selectedChildId.value = childrenList.any(
          (child) => child.id == savedChildId,
        )
            ? savedChildId!
            : childrenList.first.id;
      }
    } catch (error) {
      Get.log('Could not load children: $error');
      AppSnackbar.error('تعذر تحميل بيانات الأطفال، حاول مجدداً');
    }
  }

  void selectChild(String id) {
    selectedChildId.value = id;
  }

  Future<void> proceedToChildDetails() async {
    final int selectedIndex = childrenList.indexWhere(
      (child) => child.id == selectedChildId.value,
    );
    if (selectedIndex < 0) {
      AppSnackbar.warning('لا توجد بيانات أطفال متاحة للاختيار');
      return;
    }

    final ChildModel selectedChild = childrenList[selectedIndex];

    final age = AppDateUtils.ageFrom(selectedChild.birthDate);
    final isEligible =
        age >= AppConstants.minChildAge && age <= AppConstants.maxChildAge;

    if (isEligible) {
      try {
        final SessionService session = Get.find<SessionService>();
        await session.saveSelectedChild(selectedChild.id);
        await session.saveStep(Routes.childDetails);
        Get.toNamed(Routes.childDetails, arguments: selectedChild);
      } catch (error) {
        Get.log('Could not save the selected child: $error');
        AppSnackbar.error('تعذر حفظ اختيار الطفل، حاول مجدداً');
      }
    } else {
      Get.toNamed(Routes.verificationRejected, arguments: selectedChild);
    }
  }
}

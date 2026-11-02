import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/child_model.dart';

class ChildDetailsController extends GetxController {
  late final ChildModel selectedChild;

  String get childNationalId => selectedChild.nationalId;

  String get birthDate => AppDateUtils.format(selectedChild.birthDate);

  String get calculatedAge {
    return '${AppDateUtils.ageFrom(selectedChild.birthDate)} سنوات';
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is ChildModel) {
      selectedChild = arguments;
      return;
    }

    AppSnackbar.info('تعذر العثور على بيانات الطفل');
    Get.back();
  }

  void proceedToDashboard() {
    Get.snackbar(
      'أهلاً بك',
      'جاري الانتقال للوحة التحكم الخاصة بـ ${selectedChild.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

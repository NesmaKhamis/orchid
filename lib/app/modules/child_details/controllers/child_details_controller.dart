import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../routes/app_routes.dart';

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
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments is ChildModel) return;

    AppSnackbar.info('تعذر العثور على بيانات الطفل');
    Get.back();
  }

  Future<void> proceedToDashboard() async {
    final SessionService session = Get.find<SessionService>();
    try {
      await session.saveSelectedChild(selectedChild.id);
      try {
        await Get.find<ChildrenRepository>().saveChild(selectedChild);
      } catch (error) {
        Get.log('Could not save selected child to Firestore: $error');
        AppSnackbar.warning('تعذر حفظ بيانات الطفل على الإنترنت');
      }
      await session.markRegistrationComplete();
      await session.saveStep(Routes.home);
      Get.offAllNamed(Routes.home);
    } catch (error) {
      Get.log('Could not complete child setup: $error');
      AppSnackbar.error('تعذر إكمال إعداد الطفل، حاول مجدداً');
    }
  }
}

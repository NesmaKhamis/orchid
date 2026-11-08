import 'package:get/get.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/child_model.dart';
import '../../../routes/app_routes.dart';

class VerificationRejectedController extends GetxController {
  ChildModel? _child;

  ChildModel? get child => _child;

  String get childName => _child?.name ?? '';

  int get age => _child == null ? 0 : AppDateUtils.ageFrom(_child!.birthDate);

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is ChildModel) {
      _child = arguments;
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments is ChildModel) return;

    Get.offAllNamed(Routes.onboarding);
  }
}

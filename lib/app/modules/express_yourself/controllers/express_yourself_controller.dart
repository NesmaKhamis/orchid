import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

/// Controller for the ExpressYourself screen (creativity garden).
class ExpressYourselfController extends GetxController {
  /// Sound toggle, UI-only for now until audio is wired.
  final isMuted = false.obs;

  void toggleSound() {
    isMuted.value = !isMuted.value;
  }

  void onFreeDrawingPressed() {
    Get.toNamed(Routes.drawing);
  }

  void onGuidedColoringPressed() {
    Get.toNamed(Routes.guidedColoring);
  }

  void onSingingPressed() {
    _soon();
  }

  // TODO: plug in the real screens for coloring and singing when built.
  void _soon() {
    AppSnackbar.info('قريباً');
  }
}

import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/audio_service.dart';
import '../../../routes/app_routes.dart';

/// Controller for the ExpressYourself screen (creativity garden).
class ExpressYourselfController extends GetxController {
  ExpressYourselfController({required AudioService audioService})
    : _audioService = audioService;

  final AudioService _audioService;

  /// Sound toggle, UI-only for now until audio is wired.
  final isMuted = false.obs;

  void toggleSound() {
    isMuted.value = !isMuted.value;
  }

  void onMascotTapped() {
    unawaited(_audioService.playMascotSound());
  }

  void onFreeDrawingPressed() {
    Get.toNamed(Routes.drawing);
  }

  void onGuidedColoringPressed() {
    Get.toNamed(Routes.guidedColoring);
  }

  void onSingingPressed() {
    Get.toNamed(Routes.singing);
  }
}

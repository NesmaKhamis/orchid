import 'package:get/get.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/services/mock_audio_service.dart';
import '../controllers/express_yourself_controller.dart';

class ExpressYourselfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioService>(() => SimulatedAudioService(), fenix: true);
    Get.lazyPut<ExpressYourselfController>(
      () => ExpressYourselfController(audioService: Get.find<AudioService>()),
    );
  }
}

import 'package:get/get.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/services/mock_audio_service.dart';
import '../../../data/repositories/mock_song_repository.dart';
import '../../../data/repositories/song_repository.dart';
import '../controllers/singing_controller.dart';

class SingingBinding extends Bindings {
  @override
  void dependencies() {
    // Swapping to a real audio engine later only touches this binding.
    Get.lazyPut<AudioService>(() => SimulatedAudioService(), fenix: true);
    Get.lazyPut<SongRepository>(() => MockSongRepository(), fenix: true);
    Get.lazyPut<SingingController>(
      () => SingingController(
        repository: Get.find<SongRepository>(),
        audioService: Get.find<AudioService>(),
      ),
      fenix: true,
    );
  }
}

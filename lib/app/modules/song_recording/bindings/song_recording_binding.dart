import 'package:get/get.dart';

import '../../../data/repositories/mock_mood_repository.dart';
import '../../../data/repositories/mood_repository.dart';
import '../controllers/song_recording_controller.dart';

class SongRecordingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MoodRepository>()) {
      Get.lazyPut<MoodRepository>(() => MockMoodRepository(), fenix: true);
    }
    Get.lazyPut<SongRecordingController>(() => SongRecordingController());
  }
}

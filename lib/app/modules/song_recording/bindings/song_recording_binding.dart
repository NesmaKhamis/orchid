import 'package:get/get.dart';

import '../controllers/song_recording_controller.dart';

class SongRecordingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SongRecordingController>(() => SongRecordingController());
  }
}

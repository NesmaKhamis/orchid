import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/song.dart';

/// Controller for the song recording screen (شاشة تسجيل النشيد).
class SongRecordingController extends GetxController {
  late final Song song;
  bool hasSong = false;

  final isRecording = false.obs;
  final isPaused = false.obs;
  final recordingSeconds = 0.obs;
  final currentVerse = 0.obs;
  final selectedChip = ''.obs;
  final isMuted = false.obs;
  final hasUnsavedRecording = false.obs;
  final savedRecordings = <String>[].obs;

  Timer? _recordTimer;

  @override
  void onInit() {
    super.onInit();
    // Safe arguments reading: the song may be missing when the screen
    // is opened without navigation arguments.
    final Object? arguments = Get.arguments;
    if (arguments is Song) {
      song = arguments;
      hasSong = true;
    } else {
      AppSnackbar.info('تعذر العثور على النشيد');
      Get.back();
    }
  }

  /// Header pill label reflecting the current recording state.
  String get statePillLabel {
    if (isRecording.value && !isPaused.value) {
      return 'تسجيل • ${formatSeconds(recordingSeconds.value)}';
    }
    if (isPaused.value) {
      return 'متوقف مؤقتاً • ${formatSeconds(recordingSeconds.value)}';
    }
    return 'جاهز للتسجيل';
  }

  void toggleSound() {
    isMuted.value = !isMuted.value;
  }

  void selectChip(String name) {
    // TODO: play/loop the ambient sound via AudioService when wired.
    selectedChip.value = selectedChip.value == name ? '' : name;
  }

  void onPageChanged(int verseIndex) {
    currentVerse.value = verseIndex;
  }

  /// Big purple button: starts, or finishes, the recording.
  void toggleRecord() {
    if (isRecording.value) {
      finishRecording();
    } else {
      startRecording();
    }
  }

  void startRecording() {
    if (!hasSong || isRecording.value) {
      return;
    }
    // Web has no microphone capture in this app: the real implementation
    // (`record` package + path_provider) is mobile-only. Keep the guard so
    // Chrome never crashes.
    if (kIsWeb) {
      AppSnackbar.info('التسجيل الكامل متاح على الموبايل فقط');
      return;
    }
    // TODO: wire the `record` package + path_provider here (mobile only)
    // instead of this UI-only simulation.
    _recordTimer?.cancel();
    isRecording.value = true;
    isPaused.value = false;
    recordingSeconds.value = 0;
    hasUnsavedRecording.value = false;
    _recordTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => recordingSeconds.value++,
    );
  }

  void restartRecording() {
    if (!isRecording.value) {
      return;
    }
    recordingSeconds.value = 0;
  }

  void pauseRecording() {
    if (!isRecording.value || isPaused.value) {
      return;
    }
    _recordTimer?.cancel();
    isPaused.value = true;
  }

  void resumeRecording() {
    if (!isRecording.value || !isPaused.value) {
      return;
    }
    _recordTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => recordingSeconds.value++,
    );
    isPaused.value = false;
  }

  void togglePause() {
    if (isPaused.value) {
      resumeRecording();
    } else {
      pauseRecording();
    }
  }

  void finishRecording() {
    _recordTimer?.cancel();
    isRecording.value = false;
    isPaused.value = false;
    if (recordingSeconds.value > 0) {
      hasUnsavedRecording.value = true;
    }
  }

  // TODO: persist via a recordings repository (Firestore/mobile files);
  // this list preview stores labels only.
  void saveRecording() {
    if (!hasUnsavedRecording.value) {
      return;
    }
    savedRecordings
        .add('تسجيل • ${formatSeconds(recordingSeconds.value)}');
    hasUnsavedRecording.value = false;
    recordingSeconds.value = 0;
    AppSnackbar.success('تم حفظ التسجيل (معاينة)');
  }

  String formatSeconds(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _recordTimer?.cancel();
    isRecording.value = false;
    isPaused.value = false;
    super.onClose();
  }
}

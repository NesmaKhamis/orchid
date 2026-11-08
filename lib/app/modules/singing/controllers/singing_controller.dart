import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/song.dart';
import '../../../data/repositories/song_repository.dart';
import '../../../routes/app_routes.dart';

/// Controller for the singing screen (حديقة الأصوات).
class SingingController extends GetxController {
  SingingController({
    required SongRepository repository,
    required AudioService audioService,
  })  : _repository = repository,
        _audioService = audioService;

  static const List<String> backgrounds = <String>[
    'المطر',
    'العصافير',
    'الأمواج',
  ];

  final SongRepository _repository;
  final AudioService _audioService;

  late final List<Song> songs;
  final currentlyPlaying = Rxn<Song>();
  final progress = 0.0.obs;
  final selectedBackground = Rxn<String>();
  final isRecording = false.obs;
  final recordingSeconds = 0.obs;
  final isMuted = false.obs;

  Timer? _progressTimer;
  Timer? _recordTimer;

  @override
  void onInit() {
    super.onInit();
    songs = _repository.getSongs();
  }

  bool isSongPlaying(Song song) => currentlyPlaying.value?.id == song.id;

  /// Only one song plays at a time; tapping the playing card pauses it.
  void togglePlay(Song song) {
    // TODO: replace simulation with _audioService.play/pause once the
    // real audio assets exist.
    if (isSongPlaying(song)) {
      stopPlayback();
    } else {
      startPlayback(song);
    }
  }

  /// Tapping the card opens the recording screen for that song.
  void onSongCardPressed(Song song) {
    stopPlayback();
    _audioService.pause();
    Get.toNamed(Routes.songRecording, arguments: song);
  }

  void startPlayback(Song song) {
    currentlyPlaying.value = song;
    progress.value = 0;
    // TODO: remove this call when real assets exist; the no-op service
    // keeps the abstraction ready for just_audio/audioplayers.
    unawaited(_audioService.play(song.audioAsset));
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (Timer timer) {
        progress.value =
            (progress.value + 0.2 / song.durationSeconds).clamp(0.0, 1.0);
        if (progress.value >= 1) {
          stopPlayback();
        }
      },
    );
  }

  void stopPlayback() {
    // TODO: keep this call; the real service stops actual playback here.
    unawaited(_audioService.stop());
    _progressTimer?.cancel();
    currentlyPlaying.value = null;
    progress.value = 0;
  }

  void toggleBackground(String name) {
    // TODO: play/stop the ambient loop via _audioService as well.
    selectedBackground.value =
        selectedBackground.value == name ? null : name;
  }

  void toggleSound() {
    isMuted.value = !isMuted.value;
  }

  /// Record button: first tap starts, second tap saves (preview only).
  void toggleRecording() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  void startRecording() {
    // TODO: wire the `record` package and microphone permission instead.
    isRecording.value = true;
    recordingSeconds.value = 0;
    _recordTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => recordingSeconds.value++,
    );
  }

  void stopRecording() {
    _recordTimer?.cancel();
    isRecording.value = false;
    AppSnackbar.success('تم حفظ التسجيل (معاينة)');
  }

  /// "1:40" style label for a song duration.
  String formatSeconds(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get recordingLabel => formatSeconds(recordingSeconds.value);

  @override
  void onClose() {
    // Leaving the screen stops any simulated playback and the timer.
    _progressTimer?.cancel();
    _recordTimer?.cancel();
    stopPlayback();
    super.onClose();
  }
}

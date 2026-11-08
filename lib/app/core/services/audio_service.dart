/// Abstraction over audio playback so a real engine (just_audio /
/// audioplayers) can be plugged in later without touching the UI.
abstract class AudioService {
  Future<void> play(String asset);
  Future<void> pause();
  Future<void> stop();

  // TODO: Connect this no-op hook to a mascot sound when one is available.
  Future<void> playMascotSound() async {}
}

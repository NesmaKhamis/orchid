import 'audio_service.dart';

/// TODO: simulated no-op implementation; register a real engine-backed
/// service in its binding when actual audio assets exist.
class SimulatedAudioService implements AudioService {
  @override
  Future<void> play(String asset) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> playMascotSound() async {}
}

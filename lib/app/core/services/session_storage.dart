/// Abstraction over session persistence so the local implementation can be
/// replaced by a Firebase-backed one without touching the rest of the app.
abstract class SessionStorage {
  Future<bool> get onboardingSeen;
  Future<void> setOnboardingSeen(bool value);

  Future<bool> get registrationComplete;
  Future<void> setRegistrationComplete(bool value);

  Future<String?> get lastStep;
  Future<void> setLastStep(String? value);

  Future<String?> get selectedChildId;
  Future<void> setSelectedChildId(String? value);

  Future<void> clear();
}

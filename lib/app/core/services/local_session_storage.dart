import 'package:shared_preferences/shared_preferences.dart';

import 'session_storage.dart';

/// Temporary local implementation; replaced by a Firebase-backed storage later.
class LocalSessionStorage implements SessionStorage {
  static const String _onboardingSeenKey = 'session.onboardingSeen';
  static const String _isLoggedInKey = 'session.isLoggedIn';
  static const String _registrationCompleteKey = 'session.registrationComplete';
  static const String _lastStepKey = 'session.lastStep';
  static const String _selectedChildIdKey = 'session.selectedChildId';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<bool> get onboardingSeen async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  @override
  Future<void> setOnboardingSeen(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_onboardingSeenKey, value);
  }

  @override
  Future<bool> get isLoggedIn async {
    final prefs = await _prefs;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<void> setIsLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_isLoggedInKey, value);
  }

  @override
  Future<bool> get registrationComplete async {
    final prefs = await _prefs;
    return prefs.getBool(_registrationCompleteKey) ?? false;
  }

  @override
  Future<void> setRegistrationComplete(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_registrationCompleteKey, value);
  }

  @override
  Future<String?> get lastStep async {
    final prefs = await _prefs;
    return prefs.getString(_lastStepKey);
  }

  @override
  Future<void> setLastStep(String? value) async {
    final prefs = await _prefs;
    if (value == null) {
      await prefs.remove(_lastStepKey);
      return;
    }
    await prefs.setString(_lastStepKey, value);
  }

  @override
  Future<String?> get selectedChildId async {
    final prefs = await _prefs;
    return prefs.getString(_selectedChildIdKey);
  }

  @override
  Future<void> setSelectedChildId(String? value) async {
    final prefs = await _prefs;
    if (value == null) {
      await prefs.remove(_selectedChildIdKey);
      return;
    }
    await prefs.setString(_selectedChildIdKey, value);
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_onboardingSeenKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_registrationCompleteKey);
    await prefs.remove(_lastStepKey);
    await prefs.remove(_selectedChildIdKey);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import 'session_storage.dart';

/// SharedPreferences backing for device-level onboarding and the local cache.
class LocalSessionStorage implements SessionStorage {
  LocalSessionStorage() : _userId = null;

  LocalSessionStorage._forUser(this._userId);

  final String? _userId;

  LocalSessionStorage forUser(String userId) =>
      LocalSessionStorage._forUser(userId);

  static const String _onboardingSeenKey = 'session.onboardingSeen';
  static const String _registrationCompleteKey = 'session.registrationComplete';
  static const String _lastStepKey = 'session.lastStep';
  static const String _selectedChildIdKey = 'session.selectedChildId';

  String _userKey(String key) => _userId == null ? key : '$key.$_userId';

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
  Future<bool> get registrationComplete async {
    final prefs = await _prefs;
    return prefs.getBool(_userKey(_registrationCompleteKey)) ?? false;
  }

  @override
  Future<void> setRegistrationComplete(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_userKey(_registrationCompleteKey), value);
  }

  @override
  Future<String?> get lastStep async {
    final prefs = await _prefs;
    return prefs.getString(_userKey(_lastStepKey));
  }

  @override
  Future<void> setLastStep(String? value) async {
    final prefs = await _prefs;
    final String key = _userKey(_lastStepKey);
    if (value == null) {
      await prefs.remove(key);
      return;
    }
    await prefs.setString(key, value);
  }

  @override
  Future<String?> get selectedChildId async {
    final prefs = await _prefs;
    return prefs.getString(_userKey(_selectedChildIdKey));
  }

  @override
  Future<void> setSelectedChildId(String? value) async {
    final prefs = await _prefs;
    final String key = _userKey(_selectedChildIdKey);
    if (value == null) {
      await prefs.remove(key);
      return;
    }
    await prefs.setString(key, value);
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_onboardingSeenKey);
    await prefs.remove('session.isLoggedIn');
    await prefs.remove(_userKey(_registrationCompleteKey));
    await prefs.remove(_userKey(_lastStepKey));
    await prefs.remove(_userKey(_selectedChildIdKey));
  }
}

import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'session_storage.dart';

/// Single owner of the start-flow session state.
class SessionService extends GetxService {
  SessionService(this._storage);

  final SessionStorage _storage;

  bool _onboardingSeen = false;
  bool _isLoggedIn = false;
  bool _registrationComplete = false;
  String? _lastStep;
  String? _selectedChildId;

  bool get onboardingSeen => _onboardingSeen;
  bool get isLoggedIn => _isLoggedIn;
  bool get registrationComplete => _registrationComplete;
  String? get lastStep => _lastStep;
  String? get selectedChildId => _selectedChildId;

  Future<void> init() async {
    _onboardingSeen = await _storage.onboardingSeen;
    _isLoggedIn = await _storage.isLoggedIn;
    _registrationComplete = await _storage.registrationComplete;
    _lastStep = await _storage.lastStep;
    _selectedChildId = await _storage.selectedChildId;
  }

  Future<void> markOnboardingSeen() async {
    _onboardingSeen = true;
    await _storage.setOnboardingSeen(true);
  }

  Future<void> markLoggedIn() async {
    _isLoggedIn = true;
    await _storage.setIsLoggedIn(true);
  }

  Future<void> saveStep(String routeName) async {
    _lastStep = routeName;
    await _storage.setLastStep(routeName);
  }

  Future<void> saveSelectedChild(String childId) async {
    _selectedChildId = childId;
    await _storage.setSelectedChildId(childId);
  }

  Future<void> markRegistrationComplete() async {
    _registrationComplete = true;
    await _storage.setRegistrationComplete(true);
  }

  Future<void> markRegistrationIncomplete() async {
    _registrationComplete = false;
    await _storage.setRegistrationComplete(false);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _registrationComplete = false;
    _lastStep = null;
    _selectedChildId = null;

    await _storage.setIsLoggedIn(false);
    await _storage.setRegistrationComplete(false);
    await _storage.setLastStep(null);
    await _storage.setSelectedChildId(null);
  }

  String resolveStartRoute() {
    if (!_onboardingSeen) {
      return Routes.onboarding;
    }

    if (!_isLoggedIn) {
      return Routes.login;
    }

    if (_registrationComplete) {
      return Routes.home;
    }

    final step = _lastStep;
    if (step == null) {
      return Routes.linkIdentity;
    }

    final hasSelectedChild =
        _selectedChildId != null && _selectedChildId!.isNotEmpty;

    switch (step) {
      case Routes.linkIdentity:
      case Routes.selectChildren:
        return step;
      case Routes.privacy:
      case Routes.phoneVerification:
        return hasSelectedChild ? step : Routes.selectChildren;
      default:
        return Routes.linkIdentity;
    }
  }
}

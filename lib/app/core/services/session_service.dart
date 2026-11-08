import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';
import 'session_storage.dart';

/// Single owner of the start-flow session state.
class SessionService extends GetxService {
  SessionService(this._storage, this._authRepository);

  final SessionStorage _storage;
  final AuthRepository _authRepository;

  bool _onboardingSeen = false;
  bool _isLoggedIn = false;
  bool _registrationComplete = false;
  String? _lastStep;
  String? _selectedChildId;
  StreamSubscription<String?>? _authSubscription;
  Future<void>? _initFuture;

  bool get onboardingSeen => _onboardingSeen;
  bool get isLoggedIn => _isLoggedIn;
  bool get registrationComplete => _registrationComplete;
  String? get lastStep => _lastStep;
  String? get selectedChildId => _selectedChildId;

  Future<void> init() => _initFuture ??= _initialize();

  Future<void> _initialize() async {
    final Completer<void> authStateReady = Completer<void>();
    _authSubscription = _authRepository.authStateChanges.listen(
      (_) {
        _isLoggedIn = _authRepository.currentUserId != null;
        if (!authStateReady.isCompleted) {
          authStateReady.complete();
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Could not observe Firebase authentication state: $error');
        _isLoggedIn = _authRepository.currentUserId != null;
        if (!authStateReady.isCompleted) {
          authStateReady.complete();
        }
      },
    );

    await authStateReady.future;
    _onboardingSeen = await _storage.onboardingSeen;
    _registrationComplete = await _storage.registrationComplete;
    _lastStep = await _storage.lastStep;
    _selectedChildId = await _storage.selectedChildId;
  }

  Future<void> markOnboardingSeen() async {
    _onboardingSeen = true;
    await _storage.setOnboardingSeen(true);
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
    _registrationComplete = false;
    _lastStep = null;
    _selectedChildId = null;

    await _storage.setRegistrationComplete(false);
    await _storage.setLastStep(null);
    await _storage.setSelectedChildId(null);
    await _authRepository.signOut();
  }

  Future<String> resolveStartRoute() async {
    await init();

    _isLoggedIn = _authRepository.currentUserId != null;
    if (!_onboardingSeen) {
      return Routes.onboarding;
    }

    if (!_isLoggedIn) {
      return Routes.login;
    }

    if (!_authRepository.isEmailVerified) {
      await markRegistrationIncomplete();
      await saveStep(Routes.emailVerification);
      return Routes.emailVerification;
    }

    if (_registrationComplete) {
      return Routes.home;
    }

    final step = _lastStep;
    if (step == null) {
      return Routes.linkIdentity;
    }

    switch (step) {
      case Routes.linkIdentity:
      case Routes.selectChildren:
        return step;
      case Routes.childDetails:
        return Routes.selectChildren;
      case Routes.emailVerification:
        return Routes.linkIdentity;
      case Routes.privacy:
        return Routes.linkIdentity;
      default:
        return Routes.linkIdentity;
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}

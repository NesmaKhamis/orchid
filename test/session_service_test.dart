import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orchid_app/app/core/services/session_service.dart';
import 'package:orchid_app/app/core/services/local_session_storage.dart';
import 'package:orchid_app/app/core/services/session_storage.dart';
import 'package:orchid_app/app/data/repositories/auth_repository.dart';
import 'package:orchid_app/app/routes/app_routes.dart';

void main() {
  test('local session cache is scoped to each Firebase user', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final LocalSessionStorage storage = LocalSessionStorage();

    await storage.forUser('user-1').setSelectedChildId('child-1');

    expect(await storage.forUser('user-1').selectedChildId, 'child-1');
    expect(await storage.forUser('user-2').selectedChildId, isNull);
  });

  test('start route waits for Firebase authentication state', () async {
    final _TestAuthRepository authRepository = _TestAuthRepository();
    final SessionService session = SessionService(
      _TestSessionStorage(),
      authRepository,
    );

    final Future<String> route = session.resolveStartRoute();
    await Future<void>.delayed(Duration.zero);

    expect(session.isLoggedIn, isFalse);
    authRepository.emit('user-1');

    expect(await route, Routes.privacy);
    expect(session.isLoggedIn, isTrue);

    session.onClose();
    await authRepository.dispose();
  });
}

class _TestAuthRepository implements AuthRepository {
  final StreamController<String?> _authChanges =
      StreamController<String?>.broadcast(sync: true);

  String? _currentUserId;

  @override
  Stream<String?> get authStateChanges => _authChanges.stream;

  @override
  String? get currentUserId => _currentUserId;

  void emit(String? userId) {
    _currentUserId = userId;
    _authChanges.add(userId);
  }

  Future<void> dispose() => _authChanges.close();

  @override
  Future<void> signIn({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() async => emit(null);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) => throw UnimplementedError();
}

class _TestSessionStorage implements SessionStorage {
  @override
  Future<bool> get onboardingSeen async => true;

  @override
  Future<void> setOnboardingSeen(bool value) async {}

  @override
  Future<bool> get registrationComplete async => false;

  @override
  Future<void> setRegistrationComplete(bool value) async {}

  @override
  Future<String?> get lastStep async => Routes.privacy;

  @override
  Future<void> setLastStep(String? value) async {}

  @override
  Future<String?> get selectedChildId async => 'child-1';

  @override
  Future<void> setSelectedChildId(String? value) async {}

  @override
  Future<void> clear() async {}
}

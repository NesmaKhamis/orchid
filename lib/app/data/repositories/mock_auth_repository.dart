import 'dart:async';

import '../models/auth_failure.dart';
import 'auth_repository.dart';

/// In-memory implementation kept for tests and for running the auth screens
/// without Firebase. It is not registered in production bindings.
class MockAuthRepository implements AuthRepository {
  static const Duration _delay = Duration(milliseconds: 200);

  final Map<String, _MockAccount> _accounts = <String, _MockAccount>{};
  final StreamController<String?> _authStateController =
      StreamController<String?>.broadcast();

  String? _currentUserId;
  String _currentEmail = '';

  @override
  Stream<String?> get authStateChanges => _authStateController.stream;

  @override
  String? get currentUserId => _currentUserId;

  @override
  String get currentEmail => _currentEmail;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future<void>.delayed(_delay);
    final String normalizedEmail = email.trim().toLowerCase();

    if (_accounts.containsKey(normalizedEmail)) {
      throw const AuthFailure(
        'هذا البريد الإلكتروني مسجّل مسبقاً',
        code: 'email-already-in-use',
      );
    }
    if (password.length < 6) {
      throw const AuthFailure(
        'كلمة المرور ضعيفة، استخدم 6 أحرف على الأقل',
        code: 'weak-password',
      );
    }

    final String uid = 'mock-${_accounts.length + 1}';
    _accounts[normalizedEmail] = _MockAccount(
      uid: uid,
      name: name.trim(),
      password: password,
    );
    _setCurrentUser(uid, normalizedEmail);
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    final String normalizedEmail = email.trim().toLowerCase();
    final _MockAccount? account = _accounts[normalizedEmail];

    if (account == null) {
      throw const AuthFailure(
        'لا يوجد حساب بهذا البريد الإلكتروني',
        code: 'user-not-found',
      );
    }
    if (account.password != password) {
      throw const AuthFailure(
        'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        code: 'wrong-password',
      );
    }

    _setCurrentUser(account.uid, normalizedEmail);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(_delay);
    _setCurrentUser(null, '');
  }

  @override
  Future<void> sendEmailVerification() async {
    await Future<void>.delayed(_delay);
    // Mock: nothing to send. The Firebase implementation sends the real link.
  }

  @override
  Future<bool> reloadAndCheckVerified() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // Mock: always verified. The Firebase implementation reloads the user
    // and returns emailVerified.
    return true;
  }

  void _setCurrentUser(String? uid, String email) {
    _currentUserId = uid;
    _currentEmail = email;
    _authStateController.add(uid);
  }
}

class _MockAccount {
  const _MockAccount({
    required this.uid,
    required this.name,
    required this.password,
  });

  final String uid;
  final String name;
  final String password;
}
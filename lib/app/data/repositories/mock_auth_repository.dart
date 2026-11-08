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

  @override
  Stream<String?> get authStateChanges => _authStateController.stream;

  @override
  String? get currentUserId => _currentUserId;

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
    _setCurrentUser(uid);
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    final _MockAccount? account = _accounts[email.trim().toLowerCase()];

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

    _setCurrentUser(account.uid);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(_delay);
    _setCurrentUser(null);
  }

  void _setCurrentUser(String? uid) {
    _currentUserId = uid;
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

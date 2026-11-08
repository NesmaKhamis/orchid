import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../models/auth_failure.dart';
import 'auth_repository.dart';

/// Firebase implementation of [AuthRepository].
///
/// FirebaseAuth owns the session; Firestore keeps the parent profile in
/// `users/{uid}`. Errors are mapped to friendly Arabic messages here so the
/// controllers never see provider codes.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth,
      _firestore = firestore;

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  // Resolved lazily so creating the repository never throws on platforms where
  // Firebase is not configured (web/iOS/desktop while the rollout is Android-first).
  FirebaseAuth get _authInstance => _auth ??= FirebaseAuth.instance;
  FirebaseFirestore get _firestoreInstance =>
      _firestore ??= FirebaseFirestore.instance;

  @override
  Stream<String?> get authStateChanges {
    try {
      return _authInstance.authStateChanges().map((user) => user?.uid);
    } catch (error) {
      debugPrint('Auth state stream unavailable: $error');
      return Stream<String?>.value(null);
    }
  }

  @override
  String? get currentUserId {
    try {
      return _authInstance.currentUser?.uid;
    } catch (error) {
      debugPrint('Cannot read the current Firebase user: $error');
      return null;
    }
  }

  @override
  bool get isEmailVerified => _authInstance.currentUser?.emailVerified ?? false;

  @override
  String get currentEmail {
    try {
      return _authInstance.currentUser?.email ?? '';
    } catch (error) {
      debugPrint('Cannot read the current Firebase email: $error');
      return '';
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final String trimmedEmail = email.trim();
    final String trimmedName = name.trim();

    try {
      final credential = await _authInstance.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure(AppStrings.genericError);
      }

      await user.updateDisplayName(trimmedName);
      await _firestoreInstance
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set({
            'name': trimmedName,
            'email': trimmedEmail,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } on FirebaseAuthException catch (error) {
      throw _mapException(error);
    } on AuthFailure {
      rethrow;
    } catch (error) {
      debugPrint('Sign-up failed: $error');
      throw const AuthFailure(AppStrings.genericError);
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw _mapException(error);
    } catch (error) {
      debugPrint('Sign-in failed: $error');
      throw const AuthFailure(AppStrings.genericError);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authInstance.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapException(error);
    } catch (error) {
      debugPrint('Sign-out failed: $error');
      throw const AuthFailure(AppStrings.genericError);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final User? user = _authInstance.currentUser;
    if (user == null) {
      throw const AuthFailure(AppStrings.genericError);
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      throw _mapException(error);
    } on AuthFailure {
      rethrow;
    } catch (error) {
      debugPrint('Could not send email verification: $error');
      throw const AuthFailure(AppStrings.genericError);
    }
  }

  @override
  Future<bool> reloadAndCheckVerified() async {
    final User? user = _authInstance.currentUser;
    if (user == null) return false;

    try {
      await user.reload();
      return _authInstance.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (error) {
      throw _mapException(error);
    } on AuthFailure {
      rethrow;
    } catch (error) {
      debugPrint('Could not reload Firebase email verification state: $error');
      throw const AuthFailure(AppStrings.genericError);
    }
  }

  AuthFailure _mapException(FirebaseAuthException error) {
    final String message = switch (error.code) {
      'invalid-email' => 'صيغة البريد الإلكتروني غير صحيحة',
      'user-not-found' => 'لا يوجد حساب بهذا البريد الإلكتروني',
      'wrong-password' || 'invalid-credential' || 'invalid-login-credentials' =>
        'البريد الإلكتروني أو كلمة المرور غير صحيحة',
      'email-already-in-use' => 'هذا البريد الإلكتروني مسجّل مسبقاً',
      'weak-password' => 'كلمة المرور ضعيفة، استخدم 6 أحرف على الأقل',
      'network-request-failed' =>
        'تعذّر الاتصال بالإنترنت، تحقّق من الشبكة وحاول مجدداً',
      'too-many-requests' => 'محاولات كثيرة جداً، حاول بعد قليل',
      'user-disabled' => 'تم تعطيل هذا الحساب، تواصل مع الدعم',
      'operation-not-allowed' =>
        'تسجيل الدخول بالبريد الإلكتروني غير مفعّل حالياً',
      'requires-recent-login' => 'يرجى تسجيل الدخول مجدداً لإكمال العملية',
      _ => AppStrings.genericError,
    };

    return AuthFailure(message, code: error.code);
  }
}

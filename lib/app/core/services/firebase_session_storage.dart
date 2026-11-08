import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import 'local_session_storage.dart';
import 'session_storage.dart';

/// Stores device-level onboarding locally and user progress in Firestore.
///
/// Progress is cached locally first and falls back to that cache when Firebase
/// is unavailable.
class FirebaseSessionStorage implements SessionStorage {
  FirebaseSessionStorage({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    LocalSessionStorage? localStorage,
  }) : _auth = auth,
       _firestore = firestore,
       _localStorage = localStorage ?? LocalSessionStorage();

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  final LocalSessionStorage _localStorage;

  FirebaseAuth get _authInstance => _auth ??= FirebaseAuth.instance;
  FirebaseFirestore get _firestoreInstance =>
      _firestore ??= FirebaseFirestore.instance;

  @override
  Future<bool> get onboardingSeen => _localStorage.onboardingSeen;

  @override
  Future<void> setOnboardingSeen(bool value) =>
      _localStorage.setOnboardingSeen(value);

  @override
  Future<bool> get registrationComplete => _readField<bool>(
    'registrationComplete',
    defaultValue: false,
    readCache: (cache) => cache.registrationComplete,
    writeCache: (cache, value) => cache.setRegistrationComplete(value),
  );

  @override
  Future<void> setRegistrationComplete(bool value) => _writeField<bool>(
    'registrationComplete',
    value,
    writeCache: (cache, value) => cache.setRegistrationComplete(value),
  );

  @override
  Future<String?> get lastStep => _readField<String?>(
    'lastStep',
    defaultValue: null,
    readCache: (cache) => cache.lastStep,
    writeCache: (cache, value) => cache.setLastStep(value),
  );

  @override
  Future<void> setLastStep(String? value) => _writeField<String?>(
    'lastStep',
    value,
    writeCache: (cache, value) => cache.setLastStep(value),
  );

  @override
  Future<String?> get selectedChildId => _readField<String?>(
    'selectedChildId',
    defaultValue: null,
    readCache: (cache) => cache.selectedChildId,
    writeCache: (cache, value) => cache.setSelectedChildId(value),
  );

  @override
  Future<void> setSelectedChildId(String? value) => _writeField<String?>(
    'selectedChildId',
    value,
    writeCache: (cache, value) => cache.setSelectedChildId(value),
  );

  @override
  Future<void> clear() async {
    await _localStorage.clear();
    await setRegistrationComplete(false);
    await setLastStep(null);
    await setSelectedChildId(null);
  }

  Future<T> _readField<T>(
    String field, {
    required T defaultValue,
    required Future<T> Function(LocalSessionStorage cache) readCache,
    required Future<void> Function(LocalSessionStorage cache, T value)
    writeCache,
  }) async {
    String? uid;
    try {
      uid = _authInstance.currentUser?.uid;
      if (uid == null) {
        return defaultValue;
      }

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _userDocument(uid).get();
      final Map<String, dynamic>? profile = snapshot.data();
      if (profile != null && profile.containsKey(field)) {
        final Object? remoteValue = profile[field];
        if (remoteValue is T) {
          await writeCache(_localStorage.forUser(uid), remoteValue);
          return remoteValue;
        }
      }
    } catch (error) {
      debugPrint(
        'Could not read session field "$field" from Firestore: $error',
      );
    }

    if (uid == null) {
      return defaultValue;
    }
    return readCache(_localStorage.forUser(uid));
  }

  Future<void> _writeField<T>(
    String field,
    T value, {
    required Future<void> Function(LocalSessionStorage cache, T value)
    writeCache,
  }) async {
    String? uid;
    try {
      uid = _authInstance.currentUser?.uid;
    } catch (error) {
      debugPrint('Could not resolve the Firebase user for "$field": $error');
    }

    final LocalSessionStorage cache = uid == null
        ? _localStorage
        : _localStorage.forUser(uid);
    await writeCache(cache, value);
    if (uid == null) {
      return;
    }

    try {
      await _userDocument(uid).set({field: value}, SetOptions(merge: true));
    } catch (error) {
      debugPrint('Could not write session field "$field" to Firestore: $error');
    }
  }

  DocumentReference<Map<String, dynamic>> _userDocument(String uid) =>
      _firestoreInstance.collection(AppConstants.usersCollection).doc(uid);
}

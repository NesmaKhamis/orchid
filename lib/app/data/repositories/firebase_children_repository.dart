import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../models/child_model.dart';
import 'children_repository.dart';
import 'mock_child_repository.dart';

class FirebaseChildrenRepository implements ChildrenRepository {
  FirebaseChildrenRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    ChildrenRepository? emptyFallback,
  }) : _auth = auth,
       _firestore = firestore,
       _emptyFallback = emptyFallback ?? MockChildRepository();

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  final ChildrenRepository _emptyFallback;

  FirebaseAuth get _authInstance => _auth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestoreInstance =>
      _firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ChildModel>> getChildren() async {
    try {
      final String? uid = _authInstance.currentUser?.uid;
      if (uid == null) {
        return _loadFallbackChildren();
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestoreInstance
              .collection(AppConstants.usersCollection)
              .doc(uid)
              .collection('children')
              .get();

      final List<ChildModel> children = snapshot.docs
          .map((document) => ChildModel.fromMap(document.id, document.data()))
          .toList(growable: false);

      return children.isEmpty ? _loadFallbackChildren() : children;
    } catch (error, stackTrace) {
      debugPrint('Could not load children from Firestore; using defaults: $error');
      debugPrintStack(stackTrace: stackTrace);
      return _loadFallbackChildren();
    }
  }

  Future<List<ChildModel>> _loadFallbackChildren() {
    return _emptyFallback.getChildren();
  }

  @override
  Future<void> saveChild(ChildModel child) async {
    final String? uid = _authInstance.currentUser?.uid;
    if (uid == null) {
      throw StateError('No signed-in Firebase user is available');
    }

    await _firestoreInstance
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('children')
        .doc(child.id)
        .set(child.toMap(), SetOptions(merge: true));
  }
}

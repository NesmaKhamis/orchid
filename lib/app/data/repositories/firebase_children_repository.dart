import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_constants.dart';
import '../models/child_model.dart';
import 'children_repository.dart';

class FirebaseChildrenRepository implements ChildrenRepository {
  FirebaseChildrenRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get _authInstance => _auth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestoreInstance =>
      _firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ChildModel>> getChildren() async {
    final String? uid = _authInstance.currentUser?.uid;
    if (uid == null) {
      throw StateError('No signed-in Firebase user is available');
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestoreInstance
            .collection(AppConstants.usersCollection)
            .doc(uid)
            .collection('children')
            .get();

    return snapshot.docs
        .map((document) => ChildModel.fromMap(document.id, document.data()))
        .toList(growable: false);
  }
}

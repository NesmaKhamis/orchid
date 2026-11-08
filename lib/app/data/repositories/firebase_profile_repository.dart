import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_constants.dart';
import '../models/profile_model.dart';
import 'profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  FirebaseProfileRepository({
    required this.childId,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final String? childId;
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get _authInstance => _auth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestoreInstance =>
      _firestore ?? FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> _userDocument(String uid) =>
      _firestoreInstance.collection(AppConstants.usersCollection).doc(uid);

  DocumentReference<Map<String, dynamic>> _profileDocument(String uid) {
    final DocumentReference<Map<String, dynamic>> userDocument = _userDocument(
      uid,
    );
    final String? selectedChildId = childId;
    return selectedChildId == null || selectedChildId.isEmpty
        ? userDocument
        : userDocument.collection('children').doc(selectedChildId);
  }

  @override
  Future<ProfileModel> getProfile() async {
    final String? uid = _authInstance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Cannot load a profile without a signed-in user.');
    }

    final DocumentReference<Map<String, dynamic>> userDocument = _userDocument(
      uid,
    );
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await userDocument.get();
    final Map<String, dynamic> profileData =
        userSnapshot.data() ?? <String, dynamic>{};
    final String? selectedChildId = childId;
    if (selectedChildId != null && selectedChildId.isNotEmpty) {
      final DocumentSnapshot<Map<String, dynamic>> childSnapshot =
          await userDocument.collection('children').doc(selectedChildId).get();
      final Map<String, dynamic>? childData = childSnapshot.data();
      if (childData != null) {
        profileData.addAll(<String, dynamic>{
          if (childData['name'] is String) 'childName': childData['name'],
          if (childData['photoUrl'] is String)
            'photoUrl': childData['photoUrl'],
          if (childData['avatarPath'] is String)
            'avatarPath': childData['avatarPath'],
        });
      }
    }
    return ProfileModel.fromMap(profileData);
  }

  @override
  Future<void> updateChildName(String name) async {
    await _profileDocument(_requireUserId()).set(<String, Object?>{
      childId == null || childId!.isEmpty ? 'childName' : 'name': name,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateAvatarPath(String path) async {
    final bool isNetworkPath =
        path.startsWith('https://') || path.startsWith('http://');
    await _profileDocument(_requireUserId()).set(<String, Object?>{
      'photoUrl': isNetworkPath ? path : '',
      'avatarPath': isNetworkPath ? '' : path,
    }, SetOptions(merge: true));
  }

  String _requireUserId() {
    final String? uid = _authInstance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Cannot update a profile without a signed-in user.');
    }
    return uid;
  }
}

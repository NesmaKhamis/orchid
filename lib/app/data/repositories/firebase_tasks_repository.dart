import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_constants.dart';
import '../models/task_model.dart';
import 'tasks_repository.dart';

class FirebaseTasksRepository implements TasksRepository {
  FirebaseTasksRepository({
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
  Future<List<TaskModel>> getTasks(String childId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _tasksCollection(childId).get();
    return snapshot.docs
        .map((document) => TaskModel.fromMap(document.id, document.data()))
        .toList(growable: false);
  }

  @override
  Future<String> addTask(String childId, TaskModel task) async {
    final DocumentReference<Map<String, dynamic>> reference =
        await _tasksCollection(childId).add(<String, Object?>{
          ...task.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });
    return reference.id;
  }

  @override
  Future<void> updateTask(String childId, TaskModel task) async {
    final String? taskId = task.id;
    if (taskId == null || taskId.isEmpty) {
      throw ArgumentError.value(taskId, 'task.id', 'A task id is required');
    }
    await _tasksCollection(childId).doc(taskId).set(
      task.toMap(),
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteTask(String childId, String taskId) =>
      _tasksCollection(childId).doc(taskId).delete();

  CollectionReference<Map<String, dynamic>> _tasksCollection(String childId) {
    if (childId.isEmpty) {
      throw ArgumentError.value(childId, 'childId', 'A child id is required');
    }
    final String? uid = _authInstance.currentUser?.uid;
    if (uid == null) {
      throw StateError('No signed-in Firebase user is available');
    }

    return _firestoreInstance
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('children')
        .doc(childId)
        .collection('tasks');
  }
}

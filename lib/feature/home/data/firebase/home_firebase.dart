import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/core/network/result_firebase.dart';
import 'package:tasky_app/feature/auth/data/model/user_model.dart';
import 'package:tasky_app/feature/home/data/model/task_model.dart';

abstract class HomeFirebase {
  static CollectionReference<TaskModel> get _getCollection {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection(UserModel.collection)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(uid)
        .collection(TaskModel.collection)
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  static Future<Result<TaskModel>> addUser(TaskModel task) async {
    try {
      final doc = _getCollection.doc();
      task.id = doc.id;
      doc.set(task);
      return Success<TaskModel>(task);
    } catch (e) {
      return ErrorState<TaskModel>(e.toString());
    }
  }

  static Future<Result<List<TaskModel>>> getTasks(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    try {
      final querySnapshot = await _getCollection
          .where('data', isEqualTo: normalizedDate.millisecondsSinceEpoch)
          .get();
      final listOfQuery = querySnapshot.docs;
      final listOfTask = listOfQuery
          .map<TaskModel>((doc) => doc.data())
          .toList();
      return Success<List<TaskModel>>(listOfTask);
    } catch (e) {
      return ErrorState<List<TaskModel>>(e.toString());
    }
  }

  static Future<Result<List<TaskModel>>> getCompletedTasks(DateTime date) async {
  final normalizedDate = DateTime(date.year, date.month, date.day);

  try {
    final snapshot = await _getCollection
        .where('data', isEqualTo: normalizedDate.millisecondsSinceEpoch)
        .where('isDone', isEqualTo: true)
        .get();

    final taskslList = snapshot.docs
        .map<TaskModel>((doc) => doc.data())
        .toList();

      return Success<List<TaskModel>>(taskslList);
    } catch (e) {
      return ErrorState<List<TaskModel>>(e.toString());
    }
  }


  static Future<Result<void>> deleteTask(String taskId) async {
    try {
      final doc = _getCollection.doc(taskId);
      await doc.delete();
      return Success<void>(null);
    } catch (e) {
      return ErrorState<void>(e.toString());
    }
  }

  static Future<Result<TaskModel>> updateTask(TaskModel task) async {
    try {
      final doc = _getCollection.doc(task.id!);
      await doc.set(task, SetOptions(merge: true));
      return Success<TaskModel>(task);
    } catch (e) {
      return ErrorState<TaskModel>(e.toString());
    }
  }
}

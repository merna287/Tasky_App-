import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/core/network/result_firebase.dart';
import 'package:tasky_app/feature/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthFunctions {
  static CollectionReference<UserModel> get _getCollection {
    return FirebaseFirestore.instance
        .collection(UserModel.collection)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<void> addUser(UserModel user) async {
    await _getCollection.doc(user.id).set(user);
  }

  static Future<Result<String>> loginUser({required String email, required String password}) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(user.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ErrorState("No user found for this email");
      } else {
        return ErrorState("Wrong password");
      }
    } catch (e) {
      return ErrorState("Error");
    }
  }
  static Future<Result<UserModel>> registerUser({required UserModel user}) async{
    try{
      final credential = await FirebaseAuth.instance. createUserWithEmailAndPassword(email: user.email! , password: user.password!);
      user.id = credential.user?.uid;
      await AuthFunctions.addUser(user);
      return Success<UserModel>(user);
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ErrorState<UserModel>("Password is too weak");
      } else {
        return ErrorState<UserModel>("Email already exists");
      }
    }
  }
}


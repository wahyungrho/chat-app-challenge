import 'package:chat_app_chalenge/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  /// NOTE: This is a declaration of current user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  /// NOTE: This is a function for get all data user from Firebase Firestore
  Stream<List<UserModel>> fetchUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      List<UserModel> users = [];

      for (var user in snapshot.docs) {
        users.add(UserModel.fromDocumentSnapshot(user));
      }

      return users;
    });
  }
}

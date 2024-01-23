import 'package:chat_app_chalenge/data/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  final FirebaseAuth auth = FirebaseAuth.instance;

  /// NOTE: This is clear a text editing field controller
  void clearTextEditing() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  /// NOTE: This is a function for register account
  Future<ResponseModel> signup() async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({'name': nameController.text, 'email': emailController.text});

      isLoading.value = false;
      nameController.clear();
      emailController.clear();
      passwordController.clear();

      clearTextEditing();

      return ResponseModel(
          status: 'success',
          timestamp: DateTime.now(),
          data: userCredential.user);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      return ResponseModel(
          status: 'error', timestamp: DateTime.now(), data: e.message);
    }
  }

  /// NOTE: This is a function for login user and access to the home page
  Future<ResponseModel> signin() async {
    try {
      isLoading.value = true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      isLoading.value = false;

      clearTextEditing();

      return ResponseModel(
          status: 'success',
          timestamp: DateTime.now(),
          data: 'Sign in successfully');
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      return ResponseModel(
          status: 'error', timestamp: DateTime.now(), data: e.message);
    }
  }

  /// NOTE: This is a function for sign out from Firebase Auth
  void signout() async {
    FirebaseAuth.instance.signOut();
  }
}

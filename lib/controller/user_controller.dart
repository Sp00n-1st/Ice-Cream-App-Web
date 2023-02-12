import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class UserController extends GetxController {
  Future<void> deleteUser(String email, String password) async {
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (error) {
      showToast(error.toString(),
          position: const ToastPosition(align: Alignment.bottomCenter));
    }
  }
}

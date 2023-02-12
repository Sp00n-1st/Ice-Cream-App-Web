import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../view/login_page.dart';
import '../view/main_view.dart';
import 'controller.dart';

class AuthController extends GetxController {
  var controller = Get.put(Controller());

  Future<void> loginAdmin(
      BuildContext? context, String email, String password) async {
    if (email == 'icecream@gmail.com') {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.off(MainView());
      controller.isLogin.value = !controller.isLogin.value;
      showToast('Login Success',
          position: const ToastPosition(align: Alignment.bottomCenter),
          backgroundColor: const Color(0xff00AA13));
    } else {
      controller.isLogin.value = !controller.isLogin.value;
      showCupertinoDialog(
        context: context!,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              'You don\'t have permisson to access this web!',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            content: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.red,
                  size: 80,
                ),
              ],
            ),
            actions: [
              MaterialButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        },
      );
    }
  }

  Future<void> logoutAuth() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(const LoginPage());
    showToast('You Are Logout',
        position: const ToastPosition(align: Alignment.bottomCenter));
  }
}

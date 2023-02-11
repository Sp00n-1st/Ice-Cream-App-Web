import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_firebase/controller/controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../model/user.dart';
import '../view/login_page.dart';
import '../view/main_view.dart';

class DataBaseServices {
  var controller = Get.put(Controller());
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  String? downloadUrl;
  Future<String?> getData(String loc) async {
    try {
      await downloadUrlEx(loc);
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadUrlEx(String loc) async {
    downloadUrl =
        await FirebaseStorage.instance.ref().child('$loc').getDownloadURL();
  }

  Future<void> deleteImage(String loc) async {
    FirebaseStorage.instance.ref().storage.refFromURL(loc).delete();
  }

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

  Future<void> loginAuth(BuildContext? context, UserAccount? user, String email,
      String password) async {
    if (user!.isDisable == false) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.off(MainView());
      controller.isLogin.value = !controller.isLogin.value;
      showToast('Login Success',
          position: const ToastPosition(align: Alignment.bottomCenter),
          backgroundColor: const Color(0xff00AA13));
    } else if (email == 'icecream@gmail.com') {
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
              'You can\'t login because you\'ve been banned',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            content: Column(
              children: [
                const Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.red,
                  size: 80,
                ),
                Text(
                  'Contact Sweet Dream customer service for more information',
                  style: GoogleFonts.poppins(fontSize: 14),
                )
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

  Future<void> createUserWithEmail(String email, String password,
      String encryptPass, String firstName, String lastName) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await createUserToStorage(
        email, encryptPass, auth.currentUser!.uid, firstName, lastName);

    Get.offAll(MainView());
    controller.isLogin.value = !controller.isLogin.value;
    showToast('Register Success',
        position: const ToastPosition(align: Alignment.bottomCenter));
  }

  Future<void> createUserToStorage(String email, String password, String uid,
      String firstName, String lastName) async {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference user = firebase.collection('user');
    await user.add({
      'uid': uid,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'isDisable': false
    });
  }

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

  encryptPass(String password) {
    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  decryptedPass(String passwordEncrypt) {
    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final decrypted =
        encrypter.decrypt(enc.Encrypted.fromBase64(passwordEncrypt), iv: iv);
    return decrypted;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import '../controller/controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var controller = Get.put(Controller());
    var authController = Get.put(AuthController());

    return Scaffold(
      //backgroundColor: const Color(0xfffad755),
      body: Stack(
        children: [
          SizedBox(
            width: sizeWidth * 1,
            height: sizeHeight * 1,
            child: Image.asset(
              'bg4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
              child: Container(
            padding: const EdgeInsets.all(30),
            width: sizeWidth * 0.7,
            height: sizeHeight * 0.9,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.poppins(fontSize: 50),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        '  Email',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 0, 30, 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          controller: emailController,
                          style: GoogleFonts.poppins(),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.orange,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Input Email'),
                        ),
                      ),
                      Text(
                        '  Password',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 0, 30, 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          obscureText: true,
                          style: GoogleFonts.poppins(),
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.orange,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Input Password'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: sizeWidth / 4.5),
                        child: TextButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: '');
                              } on FirebaseAuthException catch (e) {
                                controller.showNotification(
                                    context, e.message.toString());
                              }
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.orange.shade900),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          width: sizeWidth / 6,
                          height: sizeHeight * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder()),
                              onPressed: () async {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  try {
                                    controller.isLogin.value =
                                        !controller.isLogin.value;
                                    await authController.loginAdmin(
                                        context,
                                        emailController.text,
                                        passwordController.text);
                                  } on FirebaseAuthException catch (e) {
                                    controller.isLogin.value =
                                        !controller.isLogin.value;
                                    controller.showNotification(
                                        context, e.message.toString());
                                  }
                                } else {
                                  await FirebaseAuth.instance.signOut();
                                }
                              },
                              child: Obx(
                                () {
                                  return (controller.isLogin.value == false)
                                      ? Text(
                                          'Login',
                                          style:
                                              GoogleFonts.poppins(fontSize: 18),
                                        )
                                      : const CircularProgressIndicator(
                                          color: Colors.black,
                                          backgroundColor: Colors.white,
                                        );
                                },
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 50),
                      child: const Image(
                        image: AssetImage('ice1.png'),
                        fit: BoxFit.cover,
                      ),
                    ))
              ],
            ),
          )),
        ],
      ),
    );
  }
}

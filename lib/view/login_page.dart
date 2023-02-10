import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user.dart';
import '../service/database.dart';
import '../utils/globals.dart' as globals;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    String? email;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query<UserAccount> user = firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .withConverter<UserAccount>(
            fromFirestore: (snapshot, _) =>
                UserAccount.fromJson(snapshot.data()),
            toFirestore: (userAccount, _) => userAccount.toJson());

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
                                showNotification(context, e.message.toString());
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
                          width: sizeWidth / 5.5,
                          height: sizeHeight * 0.1,
                          child: StreamBuilder<QuerySnapshot<UserAccount>>(
                              stream: user.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (context, index) =>
                                      StatefulBuilder(
                                    builder: (context, setState) => SizedBox(
                                      width: sizeWidth / 6,
                                      height: sizeHeight * 0.06,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder()),
                                          onPressed: () async {
                                            setState(
                                              () {
                                                email = emailController.text;
                                              },
                                            );
                                            if (FirebaseAuth
                                                    .instance.currentUser ==
                                                null) {
                                              try {
                                                setState(
                                                  () {
                                                    globals.isLogin =
                                                        !globals.isLogin;
                                                  },
                                                );
                                                await DataBaseServices()
                                                    .loginAdmin(
                                                        context,
                                                        emailController.text,
                                                        passwordController
                                                            .text);
                                              } on FirebaseAuthException catch (e) {
                                                setState(
                                                  () {
                                                    globals.isLogin =
                                                        !globals.isLogin;
                                                  },
                                                );
                                                showNotification(context,
                                                    e.message.toString());
                                              }
                                            } else {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                            }
                                          },
                                          child: (globals.isLogin == false)
                                              ? Text(
                                                  'Login',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18),
                                                )
                                              : const CircularProgressIndicator(
                                                  color: Colors.black,
                                                  backgroundColor: Colors.white,
                                                )),
                                    ),
                                  ),
                                );
                              }),
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

void showNotification(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.orange.shade900,
      content: Text(message.toString())));
}

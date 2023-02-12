import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/password_controller.dart';
import '../controller/user_controller.dart';
import '../model/user.dart';
import '../view/main_view.dart';

// ignore: must_be_immutable
class ModelUser extends StatelessWidget {
  bool isDisable;
  UserAccount user;
  String id;

  ModelUser(
      {Key? key, required this.id, required this.user, required this.isDisable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userCollections = firestore.collection('user');
    var passwordController = Get.put(PasswordController());
    var userController = Get.put(UserController());

    return user.isDisable == isDisable
        ? Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: user.isDisable ? Colors.red : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.firstName,
                    maxLines: 4,
                    style: GoogleFonts.poppins(),
                  ),
                ),
                width: sizeWidth / 5,
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: user.isDisable ? Colors.red : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.lastName,
                    maxLines: 4,
                    style: GoogleFonts.poppins(),
                  ),
                ),
                width: sizeWidth / 5,
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: user.isDisable ? Colors.red : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.email,
                    maxLines: 4,
                    style: GoogleFonts.poppins(),
                  ),
                ),
                width: sizeWidth / 5,
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: user.isDisable ? Colors.red : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: user.isDisable == false
                        ? user.isLogin != null
                            ? !user.isLogin!
                                ? Text(
                                    'Logout  ${user.lastLogin}',
                                    maxLines: 4,
                                    style:
                                        GoogleFonts.poppins(color: Colors.red),
                                  )
                                : Text(
                                    'Login',
                                    maxLines: 4,
                                    style: GoogleFonts.poppins(
                                        color: Colors.green),
                                  )
                            : Text('New Register', style: GoogleFonts.poppins())
                        : Text(
                            'Banned',
                            style: GoogleFonts.poppins(),
                          )),
                width: sizeWidth / 7,
                height: 60,
              ),
              Container(
                width: sizeWidth / 5,
                height: 60,
                decoration: BoxDecoration(
                    color: user.isDisable ? Colors.red : Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user.isDisable == true
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Unbanned User',
                                          style:
                                              GoogleFonts.poppins(fontSize: 28),
                                        ),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons
                                                .person_crop_circle_badge_checkmark,
                                            color: Colors.blue,
                                            size: 75,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Are Sure To Unbanned ${user.firstName} ?',
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'No',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              userCollections
                                                  .doc(id)
                                                  .update({'isDisable': false});
                                              showToast(
                                                  'Unbanned ${user.firstName} Success',
                                                  backgroundColor:
                                                      const Color(0xff00AA13),
                                                  position: const ToastPosition(
                                                      align: Alignment
                                                          .bottomCenter));
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Yes',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(CupertinoIcons
                                .person_crop_circle_badge_checkmark),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade700),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Banned User',
                                          style:
                                              GoogleFonts.poppins(fontSize: 28),
                                        ),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .person_crop_circle_badge_xmark,
                                            color: Colors.red.shade700,
                                            size: 75,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Are Sure To Banned ${user.firstName} ?',
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'No',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              userCollections.doc(id).update({
                                                'isDisable': true,
                                                'isLogin': false
                                              });

                                              showToast(
                                                  'Banned ${user.firstName} Success',
                                                  backgroundColor:
                                                      const Color(0xff00AA13),
                                                  position: const ToastPosition(
                                                      align: Alignment
                                                          .bottomCenter));
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Yes',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(
                                CupertinoIcons.person_crop_circle_badge_xmark),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        user.isLogin == true
                            ? showToast(
                                'You Can\'t Delete User Because User Still Login!',
                                textStyle:
                                    GoogleFonts.poppins(color: Colors.white),
                                position: const ToastPosition(
                                    align: Alignment.bottomCenter),
                                backgroundColor: Colors.red)
                            : showDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Delete User',
                                        style:
                                            GoogleFonts.poppins(fontSize: 28),
                                      ),
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.delete_solid,
                                          color: Colors.red.shade700,
                                          size: 75,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Are Sure To Delete ${user.firstName} ?',
                                          style:
                                              GoogleFonts.poppins(fontSize: 18),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            var encryptPass = user.password;
                                            userCollections.doc(id).delete();
                                            userController.deleteUser(
                                                user.email,
                                                passwordController
                                                    .decryptedPass(
                                                        encryptPass));
                                            showToast(
                                                'Delete ${user.firstName} Success',
                                                backgroundColor:
                                                    const Color(0xff00AA13),
                                                position: const ToastPosition(
                                                    align: Alignment
                                                        .bottomCenter));
                                            Get.offAll(MainView(
                                              position: 2,
                                            ));
                                          },
                                          child: Text(
                                            'Yes',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black),
                                          )),
                                    ],
                                  );
                                });
                      },
                      child: const Icon(CupertinoIcons.delete_solid),
                    )
                  ],
                ),
              )
            ],
          )
        : const Center();
  }
}

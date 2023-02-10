import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user.dart';
import '../view_model/model_user.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isAscending = false;
  bool isOn = false;
  bool isDisable = false;
  String sortField = 'firstName';
  final _scroll = ScrollController();
  final _scroll2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query<UserAccount> user = firestore
        .collection('user')
        .withConverter<UserAccount>(
            fromFirestore: (snapshot, _) =>
                UserAccount.fromJson(snapshot.data()),
            toFirestore: (userAccount, _) => userAccount.toJson());
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scrollbar(
      thumbVisibility: true,
      controller: _scroll,
      child: SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot<UserAccount>>(
          stream: user.orderBy(sortField, descending: isAscending).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  margin: EdgeInsets.only(left: sizeWidth / 3),
                  child: const Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ))));
            }
            if (!snapshot.hasData) {
              return const Text('kosong');
            }
            final data = snapshot.requireData;
            return data.size == 0
                ? Container(
                    width: 500,
                    height: 500,
                    margin: const EdgeInsets.only(left: 400, bottom: 200),
                    child: Image.asset(
                      'nodata3.gif',
                      fit: BoxFit.cover,
                    ))
                : Align(
                    alignment: Alignment.topCenter,
                    child: Scrollbar(
                      controller: _scroll2,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scroll2,
                        child: Container(
                          width: sizeWidth * 0.95,
                          margin: const EdgeInsets.all(10),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Display Only User Banned',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Switch(
                                        value: isOn,
                                        onChanged: (value) {
                                          isOn = value;
                                          setState(() {
                                            isDisable = !isDisable;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: MaterialButton(
                                            onPressed: () =>
                                                getSort('firstName'),
                                            child: Center(
                                                child: Text(
                                              'First Name',
                                              style: GoogleFonts.poppins(),
                                            ))),
                                        width: sizeWidth / 5,
                                        height: 60,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: MaterialButton(
                                            onPressed: () =>
                                                getSort('lastName'),
                                            child: Center(
                                                child: Text(
                                              'Last Name',
                                              style: GoogleFonts.poppins(),
                                            ))),
                                        width: sizeWidth / 5,
                                        height: 60,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: MaterialButton(
                                            onPressed: () => getSort('email'),
                                            child: Center(
                                                child: Text(
                                              'Email',
                                              style: GoogleFonts.poppins(),
                                            ))),
                                        width: sizeWidth / 5,
                                        height: 60,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: MaterialButton(
                                            onPressed: () => getSort('isLogin'),
                                            child: Center(
                                                child: Text(
                                              'Status',
                                              style: GoogleFonts.poppins(),
                                            ))),
                                        width: sizeWidth / 7,
                                        height: 60,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text(
                                          'Options',
                                          style: GoogleFonts.poppins(),
                                        )),
                                        width: sizeWidth / 5,
                                        height: 60,
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: data.size,
                                      itemBuilder: (context, index) =>
                                          ModelUser(
                                            id: data.docs[index].id,
                                            user: data.docs[index].data(),
                                            isDisable: isDisable,
                                          ))
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  getSort(String field) {
    setState(() {
      sortField = field;
      isAscending = !isAscending;
    });
  }
}

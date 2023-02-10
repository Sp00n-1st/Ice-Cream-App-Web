import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ModelDashboard extends StatelessWidget {
  String title, image;
  Query path;
  IconData icon;

  ModelDashboard(
      {Key? key,
      required this.icon,
      required this.title,
      required this.image,
      required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: const Color(0xff404258),
                ),
                Text(
                  '$title :',
                  style: GoogleFonts.poppins(
                      fontSize: 20, color: const Color(0xff404258)),
                )
              ]),
          StreamBuilder<QuerySnapshot>(
              stream: path.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.size.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 20, color: const Color(0xff404258)),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error');
                }
                return const CircularProgressIndicator();
              })
        ],
      )),
    );
  }
}

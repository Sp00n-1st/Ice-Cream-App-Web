import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../view_model/model_dashboard.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
    return Scaffold(
        body: Container(
      width: sizeWidth,
      margin: EdgeInsets.fromLTRB(
          sizeWidth * 0.25, sizeHeight * 0.15, sizeWidth * 0.25, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ModelDashboard(
                title: 'Product',
                image: 'bgmain1.jpg',
                path: firebase.collection('product'),
                icon: Icons.icecream,
              ),
              const SizedBox(
                width: 20,
              ),
              ModelDashboard(
                title: 'Order',
                image: 'bgmain2.jpg',
                path: firebase
                    .collection('order')
                    .where('isReady', isEqualTo: false),
                icon: CupertinoIcons.cart_fill,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ModelDashboard(
                  icon: CupertinoIcons.person_crop_circle_fill,
                  title: 'User',
                  image: 'bgmain3.jpg',
                  path: firebase
                      .collection('user')
                      .where('isDisable', isEqualTo: false)),
              const SizedBox(
                width: 20,
              ),
              ModelDashboard(
                  icon: CupertinoIcons.person_crop_circle_badge_xmark,
                  title: ' User Banned',
                  image: 'bgmain4.jpg',
                  path: firebase
                      .collection('user')
                      .where('isDisable', isEqualTo: true))
            ],
          )
        ],
      ),
    ));
  }
}

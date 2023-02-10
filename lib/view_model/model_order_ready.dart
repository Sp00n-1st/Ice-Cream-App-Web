import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'textbox_cart.dart';
import '../model/order_ready.dart';

// ignore: must_be_immutable
class ModelOrderReady extends StatelessWidget {
  bool isDisable;
  OrderReady orderReady;
  String id;

  ModelOrderReady(
      {Key? key,
      required this.id,
      required this.orderReady,
      required this.isDisable})
      : super(key: key);

  List<Widget> listProduct = <Widget>[];
  List<Widget> listQty = <Widget>[];
  List<Widget> listDiscount = <Widget>[];
  List<Widget> listSubtotal = <Widget>[];
  List<Widget> listAvalaible = <Widget>[];
  List<Widget> listTotal = <Widget>[];
  List<Widget> listPrice = <Widget>[];
  List<bool> available = <bool>[];
  double total = 0;
  bool? isAvailable;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = firestore.collection('user');
    var productInfo = FirebaseFirestore.instance.collection('product');

    for (int i = 0; i < orderReady.idProduct.length; i++) {
      String path = orderReady.idProduct[i];
      listProduct.add(StreamBuilder<DocumentSnapshot>(
        stream: productInfo.doc(path).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Container(
              padding: const EdgeInsets.only(left: 10, top: 10),
              height: 39,
              width: sizeWidth / 5,
              child: Text(
                snapshot.data!['nameProduct'],
                style: GoogleFonts.poppins(),
              ));
        },
      ));
    }

    for (int i = 0; i < orderReady.total.length; i++) {
      listTotal.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(
            NumberFormat.currency(locale: 'en', symbol: '£ ')
                .format(orderReady.total[i]),
            style: GoogleFonts.poppins(),
          ))));
    }

    for (int i = 0; i < orderReady.available.length; i++) {
      if (orderReady.available[i] == false) {
      } else {
        total += orderReady.total[i];
      }
    }

    for (int i = 0; i < orderReady.discount.length; i++) {
      listDiscount.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(
            NumberFormat.currency(locale: 'en', symbol: '£ ')
                .format(orderReady.discount[i]),
            style: GoogleFonts.poppins(),
          ))));
    }

    for (int i = 0; i < orderReady.subTotal.length; i++) {
      listSubtotal.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(
            NumberFormat.currency(locale: 'en', symbol: '£ ')
                .format(orderReady.subTotal[i]),
            style: GoogleFonts.poppins(),
          ))));
    }

    for (int i = 0; i < orderReady.qty.length; i++) {
      listQty.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(
            orderReady.qty[i].toString(),
            style: GoogleFonts.poppins(),
          ))));
    }

    for (int i = 0; i < orderReady.available.length; i++) {
      if (orderReady.available[i] == false) {
        listPrice.add(SizedBox(
            height: 39,
            width: sizeWidth / 5,
            child: Center(
                child: Text(
              '£ 0.00',
              style: GoogleFonts.poppins(),
            ))));
      } else {
        listPrice.add(SizedBox(
            height: 39,
            width: sizeWidth / 5,
            child: Center(
                child: Text(
              '£ ${NumberFormat.currency(locale: 'en', symbol: '').format(orderReady.price[i])}',
              style: GoogleFonts.poppins(),
            ))));
      }
    }

    for (int i = 0; i < orderReady.available.length; i++) {
      if (orderReady.available[i] == false) {
        listAvalaible.add(const IconButton(
            onPressed: null,
            icon: Icon(CupertinoIcons.clear_circled, color: Colors.red)));
      } else {
        listAvalaible.add(const IconButton(
          onPressed: null,
          icon: Icon(CupertinoIcons.checkmark_alt_circle, color: Colors.green),
        ));
      }
    }

    return orderReady.isReady == true
        ? StreamBuilder<DocumentSnapshot>(
            stream: user.doc(orderReady.uidUser).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                height: orderReady.idProduct.length * 42,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 2, color: Colors.black))),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${snapshot.data!['firstName']} ${snapshot.data!['lastName']}',
                            style: GoogleFonts.poppins(),
                          )),
                      width: sizeWidth / 10,
                    ),
                    TextboxCart(list: listProduct, size: sizeWidth / 10),
                    TextboxCart(list: listPrice, size: sizeWidth / 15),
                    TextboxCart(list: listQty, size: sizeWidth / 15),
                    TextboxCart(list: listDiscount, size: sizeWidth / 15),
                    TextboxCart(list: listSubtotal, size: sizeWidth / 15),
                    TextboxCart(list: listTotal, size: sizeWidth / 15),
                    TextboxCart(
                      list: listAvalaible,
                      size: sizeWidth / 15,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      child: Center(
                          child: Text(
                        NumberFormat.currency(locale: 'en', symbol: '£ ')
                            .format(total),
                        style: GoogleFonts.poppins(),
                      )),
                      width: sizeWidth / 10.2,
                    )
                  ],
                ),
              );
            })
        : const SizedBox();
  }
}

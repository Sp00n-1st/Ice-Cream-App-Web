import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'textbox_cart.dart';
import '../model/order.dart';

// ignore: must_be_immutable
class ModelCart extends StatelessWidget {
  bool isDisable;
  OrderModel cart;
  String id;

  ModelCart(
      {Key? key, required this.id, required this.cart, required this.isDisable})
      : super(key: key);

  List<Widget> listProduct = <Widget>[];
  List<Widget> listQty = <Widget>[];
  List<Widget> listDiscount = <Widget>[];
  List<Widget> listTotal = <Widget>[];
  List<Widget> listSubtotal = <Widget>[];
  List<Widget> listAvalaible = <Widget>[];
  List<Widget> listPrice = <Widget>[];
  List<bool?> available = <bool?>[];
  bool? isAvailable = null;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = firestore.collection('user');
    var productInfo = FirebaseFirestore.instance.collection('product');
    final orderRef = firestore.collection('order');

    for (int i = 0; i < cart.idProduct.length; i++) {
      String path = cart.idProduct[i];
      cart.idProduct.last;
      available.add(null);
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
              child: Text(snapshot.data!['nameProduct']));
        },
      ));
    }

    for (int i = 0; i < cart.qty.length; i++) {
      listQty.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(child: Text(cart.qty[i].toString()))));
    }

    for (int i = 0; i < cart.discount.length; i++) {
      listDiscount.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(NumberFormat.currency(locale: 'en', symbol: '£ ')
                  .format(cart.discount[i])))));
    }

    for (int i = 0; i < cart.subTotal.length; i++) {
      listSubtotal.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(NumberFormat.currency(locale: 'en', symbol: '£ ')
                  .format(cart.subTotal[i])))));
    }

    for (int i = 0; i < cart.total.length; i++) {
      listTotal.add(SizedBox(
          height: 39,
          width: sizeWidth / 5,
          child: Center(
              child: Text(NumberFormat.currency(locale: 'en', symbol: '£ ')
                  .format(cart.total[i])))));
    }

    for (int i = 0; i < cart.price.length; i++) {
      listPrice.add(SizedBox(
          height: 39,
          width: sizeWidth / 15,
          child: Center(
              child: Text(NumberFormat.currency(locale: 'en', symbol: '£ ')
                  .format(cart.price[i])))));
    }

    for (int i = 0; i < cart.idProduct.length; i++) {
      listAvalaible.add(SizedBox(
        width: sizeWidth / 9,
        child: StatefulBuilder(
          builder: (context, setState) {
            return (isAvailable == null)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(
                              () {
                                isAvailable = true;
                                available[i] = true;
                              },
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.checkmark_alt_circle,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(
                              () {
                                isAvailable = false;
                                available[i] = false;
                              },
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.clear_circled,
                            color: Colors.red,
                          ))
                    ],
                  )
                : isAvailable == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.clear_circled,
                                color: Colors.red,
                              ))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.checkmark_alt_circle,
                                color: Colors.green,
                              )),
                        ],
                      );
          },
        ),
      ));
    }

    return cart.isReady == false
        ? StreamBuilder<DocumentSnapshot>(
            stream: user.doc(cart.uidUser).snapshots(),
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
                height: cart.idProduct.length * 42,
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
                              '${snapshot.data!['firstName']} ${snapshot.data!['lastName']}')),
                      width: sizeWidth / 10,
                    ),
                    TextboxCart(list: listProduct, size: sizeWidth / 10),
                    TextboxCart(list: listPrice, size: sizeWidth / 15),
                    TextboxCart(list: listQty, size: sizeWidth / 15),
                    TextboxCart(list: listDiscount, size: sizeWidth / 15),
                    TextboxCart(list: listSubtotal, size: sizeWidth / 15),
                    TextboxCart(list: listTotal, size: sizeWidth / 15),
                    TextboxCart(list: listAvalaible, size: sizeWidth / 9),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                            margin: const EdgeInsets.only(left: 25),
                            width: sizeWidth / 15,
                            alignment: Alignment.center,
                            child: (cart.isTake == false)
                                ? SizedBox(
                                    width: sizeWidth / 16,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder()),
                                      onPressed: () {
                                        setState(
                                          () {
                                            cart.isTake = !cart.isTake;
                                            isReady = !isReady;
                                            orderRef.doc(id).update(
                                                ({'isTake': cart.isTake}));
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Take',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              'Are you sure this order is ready ?',
                                              style: GoogleFonts.poppins(),
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () {
                                                  if (available
                                                      .contains(null)) {
                                                    showToast(
                                                        'Check The Available Before Order Ready',
                                                        textStyle:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white),
                                                        position:
                                                            const ToastPosition(
                                                                align: Alignment
                                                                    .bottomCenter),
                                                        backgroundColor:
                                                            Colors.red);
                                                  } else {
                                                    for (int i = 0;
                                                        i < available.length;
                                                        i++) {
                                                      if (available[i] ==
                                                          false) {
                                                        cart.qty[i] = 0;
                                                        cart.total[i] = 0;
                                                        cart.subTotal[i] = 0;
                                                        cart.discount[i] = 0;
                                                      }
                                                    }
                                                    setState(
                                                      () {
                                                        isReady = !isReady;
                                                        orderRef
                                                            .doc(id)
                                                            .update(({
                                                              'isReady':
                                                                  isReady,
                                                              'qty': cart.qty,
                                                              'available':
                                                                  available,
                                                              'total':
                                                                  cart.total,
                                                              'discount':
                                                                  cart.discount,
                                                              'subTotal':
                                                                  cart.subTotal
                                                            }));
                                                      },
                                                    );
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'No',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Ready',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ));
                      },
                    ),
                  ],
                ),
              );
            })
        : const SizedBox();
  }
}

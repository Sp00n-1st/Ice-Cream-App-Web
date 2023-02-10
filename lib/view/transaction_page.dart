import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/order_ready.dart';
import '../view_model/model_order_ready.dart';
import '../view_model/textbox_display.dart';

class Transaction extends StatelessWidget {
  Transaction({Key? key}) : super(key: key);

  final _scrollC = ScrollController();

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    final firebase = FirebaseFirestore.instance;

    Query<OrderReady> orderReady = firebase
        .collection('order')
        .withConverter<OrderReady>(
            fromFirestore: (snapshot, _) =>
                OrderReady.fromJson(snapshot.data()),
            toFirestore: (orderReady, _) => orderReady.toJson());

    return Scaffold(
        body: StreamBuilder<QuerySnapshot<OrderReady>>(
      stream: orderReady.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.requireData;
          return Scrollbar(
            controller: _scrollC,
            child: SingleChildScrollView(
              controller: _scrollC,
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextboxDisplay(
                            label: 'Name Costumer', size: sizeWidth / 10),
                        TextboxDisplay(label: 'Product', size: sizeWidth / 10),
                        TextboxDisplay(label: 'Price', size: sizeWidth / 15),
                        TextboxDisplay(label: 'Qty', size: sizeWidth / 15),
                        TextboxDisplay(label: 'Discount', size: sizeWidth / 15),
                        TextboxDisplay(
                            label: 'Sub Total', size: sizeWidth / 15),
                        TextboxDisplay(label: 'Total', size: sizeWidth / 15),
                        TextboxDisplay(
                            label: 'Available', size: sizeWidth / 15),
                        TextboxDisplay(label: 'Amount', size: sizeWidth / 10),
                      ],
                    ),
                    SizedBox(
                      width: sizeWidth * 0.7,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.size,
                          itemBuilder: (context, index) => ModelOrderReady(
                                id: data.docs[index].id,
                                orderReady: data.docs[index].data(),
                                isDisable: true,
                              )),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    ));
  }
}

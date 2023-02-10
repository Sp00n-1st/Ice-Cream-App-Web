import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/order.dart';
import '../view_model/model_cart.dart';

class OrderPage extends StatelessWidget {
  final _scrollC = ScrollController();

  OrderPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    final firebase = FirebaseFirestore.instance;

    Query<OrderModel> carts = firebase
        .collection('order')
        .orderBy('time', descending: true)
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromJson(snapshot.data()),
            toFirestore: (orderModel, _) => orderModel.toJson());

    return Scaffold(
        body: StreamBuilder<QuerySnapshot<OrderModel>>(
      stream: carts.snapshots(),
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
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text('Name Customer',
                                      style: GoogleFonts.poppins()))),
                          width: sizeWidth / 10,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Product',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 10,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Price',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 15,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'QTY',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 15,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Discount',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 15,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Sub Total',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 15,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Total',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 15,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Available',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 9,
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(color: Colors.black)),
                          child: MaterialButton(
                              onPressed: () {},
                              child: Center(
                                  child: Text(
                                'Status',
                                style: GoogleFonts.poppins(),
                              ))),
                          width: sizeWidth / 10,
                          height: 60,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: sizeWidth * 0.7445,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.size,
                          itemBuilder: (context, index) => ModelCart(
                                id: data.docs[index].id,
                                cart: data.docs[index].data(),
                                isDisable: true,
                              )),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    ));
  }
}

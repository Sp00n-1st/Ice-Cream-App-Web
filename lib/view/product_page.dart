import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../view_model/model_product.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query<Product> products = firestore
        .collection('product')
        .orderBy('nameProduct', descending: false)
        .withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()),
            toFirestore: (product, _) => product.toJson());
    double sizeWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot<Product>>(
      stream: products.snapshots(),
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
            : ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) => ModelProduct(
                    id: data.docs[index].id,
                    productModel: data.docs[index].data()));
      },
    );
  }
}

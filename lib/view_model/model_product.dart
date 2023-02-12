import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/photo_controller.dart';
import '../model/product.dart';
import '../view/edit_page.dart';

// ignore: must_be_immutable
class ModelProduct extends StatelessWidget {
  final Product productModel;
  String id;

  ModelProduct({Key? key, required this.id, required this.productModel})
      : super(key: key);

  bool isEdit = false;
  int totalStock = 0;
  final stockController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    int stockNow = productModel.stock;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference product = firestore.collection('product');
    double sizeWidth = MediaQuery.of(context).size.width;
    var photoController = Get.put(PhotoController());

    return Container(
      height: sizeWidth / 4,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Color(0x05500000), offset: Offset(1, 1), blurRadius: 7)
          ],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black)),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 20,
              ),
              width: sizeWidth / 4,
              height: sizeWidth / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  productModel.imageUrl.elementAt(0),
                  fit: BoxFit.cover,
                ),
              )),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              width: sizeWidth / 5.2,
              height: sizeWidth / 4.1,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name Product : \n${productModel.nameProduct}',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Category : \n${productModel.category}',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Price : \n${productModel.price}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Description Item : \n${productModel.descItem}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Protein : \n${productModel.protein}',
                          maxLines: 4,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Calori : \n${productModel.calori}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Carbohydrate : \n${productModel.carbo}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Fat : \n${productModel.fat}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Stock : \n${productModel.stock}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.blue),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Add Stock ?'),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 15),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Material(
                                                  child: TextField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp("[0-9]")),
                                                    ],
                                                    controller: stockController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    cursorColor: Colors.blue,
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Input Stock'),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          const StadiumBorder()),
                                                  onPressed: () async {
                                                    int addStock = int.tryParse(
                                                            stockController
                                                                .text) ??
                                                        0;
                                                    totalStock =
                                                        stockNow + addStock;
                                                    await product
                                                        .doc(id)
                                                        .update(({
                                                          'stock': totalStock
                                                        }));
                                                    showToast(
                                                        'Add Stock Success!',
                                                        position:
                                                            const ToastPosition(
                                                                align: Alignment
                                                                    .bottomCenter));
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Save'))
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Icon(CupertinoIcons.add)),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.orange),
                                onPressed: () {
                                  Get.to(EditPage(
                                    productModel: productModel,
                                    id: id,
                                  ));
                                },
                                child: const Icon(CupertinoIcons.pencil)),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                          'Delete Product',
                                          style:
                                              GoogleFonts.poppins(fontSize: 18),
                                        ),
                                        content: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Icon(
                                              CupertinoIcons.delete,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Are Sure To Delete ${productModel.nameProduct} ?',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          MaterialButton(
                                              child: Text(
                                                'No',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          MaterialButton(
                                              child: Text(
                                                'Yes',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14),
                                              ),
                                              onPressed: () {
                                                product.doc(id).delete();
                                                photoController.deleteImage(
                                                    productModel.imageUrl
                                                        .elementAt(0));
                                                photoController.deleteImage(
                                                    productModel.imageUrl
                                                        .elementAt(1));
                                                showToast(
                                                    'Deleted Data Successfully',
                                                    position:
                                                        const ToastPosition(
                                                            align: Alignment
                                                                .bottomCenter),
                                                    backgroundColor:
                                                        Colors.green);
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(CupertinoIcons.delete)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

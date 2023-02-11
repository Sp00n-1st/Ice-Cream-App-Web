import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/controller.dart';
import '../controller/photo_controller.dart';
import '../view_model/textbox_input.dart';
import '../view_model/textbox_input_number.dart';
import '../model/product.dart';
import '../service/database.dart';
import 'main_view.dart';

// ignore: must_be_immutable
class EditPage extends StatelessWidget {
  final Product productModel;
  String id;
  EditPage({Key? key, required this.productModel, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController productName =
        TextEditingController(text: productModel.nameProduct);
    TextEditingController priceProduct =
        TextEditingController(text: productModel.price.toString());
    TextEditingController descItem =
        TextEditingController(text: productModel.descItem);
    TextEditingController calGram =
        TextEditingController(text: productModel.protein.toString());
    TextEditingController carGram =
        TextEditingController(text: productModel.carbo.toString());
    TextEditingController proGram =
        TextEditingController(text: productModel.calori.toString());
    TextEditingController fatGram =
        TextEditingController(text: productModel.fat.toString());
    TextEditingController stockController =
        TextEditingController(text: productModel.stock.toString());
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference product = firebase.collection('product');
    double sizeWidth = MediaQuery.of(context).size.width / 2;
    var photoController = Get.put(PhotoController());
    var controller = Get.put(Controller());
    controller.category.value = null;

    return OKToast(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Product',
            style: GoogleFonts.poppins(),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: sizeWidth,
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  TextBoxInput(
                      controller: productName, label: 'Input Product Name'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxNumber(controller: priceProduct, label: 'Input Price'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxInput(
                    controller: descItem,
                    label: 'Input Description',
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxNumber(controller: proGram, label: 'Input Protein'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxNumber(
                      controller: carGram, label: 'Input Carbohydrate'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxNumber(controller: calGram, label: 'Input Calori'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxNumber(controller: fatGram, label: 'Input Fat'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBoxNumber(
                      controller: stockController, label: 'Input Stock'),
                  Obx(
                    () => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      value: 'Gelato',
                                      groupValue: controller.category.value,
                                      onChanged: (value) {
                                        controller.category.value =
                                            value.toString();
                                      }),
                                  const Expanded(
                                    child: Text('Gelato'),
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      value: 'Ice Stick',
                                      groupValue: controller.category.value,
                                      onChanged: (value) {
                                        controller.category.value =
                                            value.toString();
                                      }),
                                  const Expanded(child: Text('Ice Stick'))
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio(
                                      value: 'Ice Cone',
                                      groupValue: controller.category.value,
                                      onChanged: (value) {
                                        controller.category.value =
                                            value.toString();
                                      }),
                                  const Expanded(child: Text('Ice Cone'))
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio(
                                      value: 'Sundae',
                                      groupValue: controller.category.value,
                                      onChanged: (value) {
                                        controller.category.value =
                                            value.toString();
                                      }),
                                  const Expanded(child: Text('Sundae'))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                    width: 50,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0.0, 0.5),
                              blurRadius: 30.0,
                            )
                          ]),
                      width: sizeWidth * 0.7,
                      height: 300.0,
                      child: Obx(
                        () {
                          return MaterialButton(
                            onPressed: photoController.pickPhotoFromGallery,
                            child: Center(
                                child: (photoController
                                        .itemPhotosWidgetList.isEmpty)
                                    ? Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              child: Center(
                                                child: Image.network(
                                                  productModel.imageUrl
                                                      .elementAt(0),
                                                  height: 100.0,
                                                  width: 100.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              child: Center(
                                                child: Image.network(
                                                  productModel.imageUrl
                                                      .elementAt(1),
                                                  height: 100.0,
                                                  width: 100.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : photoController.uploading.value
                                        ? const CircularProgressIndicator()
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Wrap(
                                              spacing: 5.0,
                                              direction: Axis.horizontal,
                                              children: photoController
                                                  .itemPhotosWidgetList,
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              runSpacing: 10.0,
                                            ),
                                          )),
                          );
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () {
                      return !photoController.uploading.value
                          ? SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  onPressed: photoController.uploading.value
                                      ? null
                                      : () async {
                                          if (productName
                                                  .value.text.isNotEmpty &&
                                              priceProduct
                                                  .value.text.isNotEmpty &&
                                              descItem.value.text.isNotEmpty &&
                                              proGram.value.text.isNotEmpty &&
                                              calGram.value.text.isNotEmpty &&
                                              fatGram.value.text.isNotEmpty &&
                                              stockController.text.isNotEmpty) {
                                            if (!priceProduct
                                                .value.text.isNum) {
                                              toastInputNumber('Price');
                                            } else if (!proGram
                                                .value.text.isNum) {
                                              toastInputNumber('Protein');
                                            } else if (!calGram
                                                .value.text.isNum) {
                                              toastInputNumber('Calori');
                                            } else if (!fatGram
                                                .value.text.isNum) {
                                              toastInputNumber('Fat');
                                            } else if (!stockController
                                                .value.text.isNum) {
                                              toastInputNumber('Stock');
                                            } else {
                                              await photoController.upload();
                                              if (photoController
                                                  .itemImagesList.isEmpty) {
                                                photoController.imageUrl!.add(
                                                    productModel.imageUrl
                                                        .elementAt(0));
                                                photoController.imageUrl!.add(
                                                    productModel.imageUrl
                                                        .elementAt(1));
                                              } else {
                                                await DataBaseServices()
                                                    .deleteImage(productModel
                                                        .imageUrl
                                                        .elementAt(0));
                                                await DataBaseServices()
                                                    .deleteImage(productModel
                                                        .imageUrl
                                                        .elementAt(1));
                                                photoController.imageUrl =
                                                    photoController
                                                        .downloadUrl!;
                                              }
                                              await product.doc(id).update({
                                                'nameProduct': productName.text,
                                                'category': (controller
                                                            .category.value ==
                                                        null)
                                                    ? productModel.category
                                                    : controller.category.value,
                                                'price': double.tryParse(
                                                        priceProduct.text) ??
                                                    0,
                                                'descItem': descItem.text,
                                                'protein': double.tryParse(
                                                        proGram.text) ??
                                                    0,
                                                'calori': double.tryParse(
                                                        calGram.text) ??
                                                    0,
                                                'fat': double.tryParse(
                                                        fatGram.text) ??
                                                    0,
                                                'carbo': double.tryParse(
                                                        carGram.text) ??
                                                    0,
                                                'imageUrl':
                                                    photoController.imageUrl,
                                                'stock': int.tryParse(
                                                        stockController.text) ??
                                                    0,
                                              });
                                              Get.offAll(MainView(
                                                position: 2,
                                              ));
                                            }
                                          } else {
                                            showToast(
                                                'Please Enter All Required Data Before Data Input!',
                                                backgroundColor: Colors.red,
                                                position: const ToastPosition(
                                                    align: Alignment
                                                        .bottomCenter));
                                          }
                                        },
                                  child: const Text('Save')),
                            )
                          : const SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  toastInputNumber(String input) {
    showToast('Please Enter A Number Format For Input $input !',
        backgroundColor: Colors.red,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/controller.dart';
import '../controller/photo_controller.dart';
import 'main_view.dart';
import '../view_model/textbox_input.dart';
import '../view_model/textbox_input_number.dart';

// ignore: must_be_immutable
class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController productName = TextEditingController();
    TextEditingController priceProduct = TextEditingController();
    TextEditingController descItem = TextEditingController();
    TextEditingController calGram = TextEditingController();
    TextEditingController proGram = TextEditingController();
    TextEditingController fatGram = TextEditingController();
    TextEditingController carGram = TextEditingController();
    TextEditingController stock = TextEditingController();
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference product = firebase.collection('product');
    double sizeWidth = MediaQuery.of(context).size.width;
    var controller = Get.put(Controller());
    var photoController = Get.put(PhotoController());
    controller.category.value = null;

    return Obx(
      () => Form(
        child: Column(
          children: [
            TextBoxInput(controller: productName, label: 'Input Product Name'),
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
            TextBoxNumber(controller: carGram, label: 'Input Carbohydrate'),
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
            TextBoxNumber(controller: stock, label: 'Input Stock'),
            const SizedBox(
              height: 20,
            ),
            Column(
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
                                controller.category.value = value.toString();
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
                                controller.category.value = value.toString();
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
                                controller.category.value = value.toString();
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
                                controller.category.value = value.toString();
                              }),
                          const Expanded(child: Text('Sundae'))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
              width: 50,
            ),
            MaterialButton(
              onPressed: photoController.pickPhotoFromGallery,
              child: Container(
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
                child: Center(
                    child: photoController.itemPhotosWidgetList.isEmpty
                        ? Center(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                child: Image.network(
                                  'https://static.thenounproject.com/png/3322766-200.png',
                                  height: 100.0,
                                  width: 100.0,
                                ),
                              ),
                            ),
                          )
                        : photoController.uploading.value
                            ? const CircularProgressIndicator()
                            : SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Wrap(
                                  spacing: 5.0,
                                  direction: Axis.horizontal,
                                  children:
                                      photoController.itemPhotosWidgetList,
                                  alignment: WrapAlignment.spaceEvenly,
                                  runSpacing: 10.0,
                                ),
                              )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            !photoController.uploading.value
                ? SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder()),
                        onPressed: () async {
                          if (productName.value.text.isNotEmpty &&
                              priceProduct.value.text.isNotEmpty &&
                              descItem.value.text.isNotEmpty &&
                              proGram.value.text.isNotEmpty &&
                              calGram.value.text.isNotEmpty &&
                              fatGram.value.text.isNotEmpty &&
                              carGram.value.text.isNotEmpty &&
                              stock.value.text.isNotEmpty &&
                              controller.category.value != null) {
                            if (!priceProduct.value.text.isNum) {
                              controller.toastInputNumber('Price');
                            } else if (!proGram.value.text.isNum) {
                              controller.toastInputNumber('Protein');
                            } else if (!calGram.value.text.isNum) {
                              controller.toastInputNumber('Calori');
                            } else if (!fatGram.value.text.isNum) {
                              controller.toastInputNumber('Fat');
                            } else if (!carGram.value.text.isNum) {
                              controller.toastInputNumber('Carbo');
                            } else if (!stock.value.text.isNum) {
                              controller.toastInputNumber('Stock');
                            } else {
                              await photoController.upload();
                              await product.add({
                                'nameProduct': productName.text,
                                'category': controller.category.value,
                                'price':
                                    double.tryParse(priceProduct.text) ?? 0,
                                'descItem': descItem.text,
                                'protein': double.tryParse(proGram.text) ?? 0,
                                'calori': double.tryParse(calGram.text) ?? 0,
                                'fat': double.tryParse(fatGram.text) ?? 0,
                                'carbo': double.tryParse(carGram.text) ?? 0,
                                'stock': double.tryParse(stock.text) ?? 0,
                                'imageUrl': photoController.downloadUrl,
                              });
                              Get.offAll(MainView(
                                position: 1,
                              ));
                            }
                          } else {
                            showToast(
                                'Please Enter All Required Data Before Data Input!',
                                backgroundColor: Colors.red,
                                position: const ToastPosition(
                                    align: Alignment.bottomCenter));
                          }
                        },
                        child: Text(
                          'Input',
                          style: GoogleFonts.poppins(),
                        )),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

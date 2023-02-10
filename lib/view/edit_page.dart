import 'dart:io' show File;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';
import '../view_model/textbox_input.dart';
import '../view_model/textbox_input_number.dart';
import 'main_view.dart';
import '../model/product.dart';
import '../service/database.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  final Product product;
  String id;
  EditPage({Key? key, required this.product, required this.id})
      : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<Widget> itemPhotosWidgetList = <Widget>[];
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  List<String>? downloadUrl = <String>[];
  String? category;
  List<String>? imageUrl = <String>[];
  bool uploading = false;
  String? pId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    TextEditingController productName =
        TextEditingController(text: widget.product.nameProduct);
    TextEditingController priceProduct =
        TextEditingController(text: widget.product.price.toString());
    TextEditingController descItem =
        TextEditingController(text: widget.product.descItem);
    TextEditingController calGram =
        TextEditingController(text: widget.product.protein.toString());
    TextEditingController carGram =
        TextEditingController(text: widget.product.carbo.toString());
    TextEditingController proGram =
        TextEditingController(text: widget.product.calori.toString());
    TextEditingController fatGram =
        TextEditingController(text: widget.product.fat.toString());
    TextEditingController stockController =
        TextEditingController(text: widget.product.stock.toString());
    FirebaseFirestore firebase = FirebaseFirestore.instance;

    CollectionReference product = firebase.collection('product');

    double sizeWidth = MediaQuery.of(context).size.width / 2;
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
                                    groupValue: category,
                                    onChanged: (value) {
                                      setState(() {
                                        category = value.toString();
                                      });
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
                                    groupValue: category,
                                    onChanged: (value) {
                                      setState(() {
                                        category = value.toString();
                                      });
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
                                    groupValue: category,
                                    onChanged: (value) {
                                      setState(() {
                                        category = value.toString();
                                      });
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
                                    groupValue: category,
                                    onChanged: (value) {
                                      setState(() {
                                        category = value.toString();
                                      });
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
                    child: MaterialButton(
                      onPressed: pickPhotoFromGallery,
                      child: Center(
                          child: (itemPhotosWidgetList.isEmpty)
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Center(
                                          child: Image.network(
                                            widget.product.imageUrl
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
                                            widget.product.imageUrl
                                                .elementAt(1),
                                            height: 100.0,
                                            width: 100.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : uploading
                                  ? const CircularProgressIndicator()
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Wrap(
                                        spacing: 5.0,
                                        direction: Axis.horizontal,
                                        children: itemPhotosWidgetList,
                                        alignment: WrapAlignment.spaceEvenly,
                                        runSpacing: 10.0,
                                      ),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  !uploading
                      ? SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder()),
                              onPressed: uploading
                                  ? null
                                  : () async {
                                      if (productName.value.text.isNotEmpty &&
                                          priceProduct.value.text.isNotEmpty &&
                                          descItem.value.text.isNotEmpty &&
                                          proGram.value.text.isNotEmpty &&
                                          calGram.value.text.isNotEmpty &&
                                          fatGram.value.text.isNotEmpty &&
                                          stockController.text.isNotEmpty) {
                                        if (!priceProduct.value.text.isNum) {
                                          toastInputNumber('Price');
                                        } else if (!proGram.value.text.isNum) {
                                          toastInputNumber('Protein');
                                        } else if (!calGram.value.text.isNum) {
                                          toastInputNumber('Calori');
                                        } else if (!fatGram.value.text.isNum) {
                                          toastInputNumber('Fat');
                                        } else if (!stockController
                                            .value.text.isNum) {
                                          toastInputNumber('Stock');
                                        } else {
                                          await upload();
                                          if (itemImagesList.isEmpty) {
                                            imageUrl!.add(widget
                                                .product.imageUrl
                                                .elementAt(0));
                                            imageUrl!.add(widget
                                                .product.imageUrl
                                                .elementAt(1));
                                          } else {
                                            await DataBaseServices()
                                                .deleteImage(widget
                                                    .product.imageUrl
                                                    .elementAt(0));
                                            await DataBaseServices()
                                                .deleteImage(widget
                                                    .product.imageUrl
                                                    .elementAt(1));
                                            imageUrl = downloadUrl!;
                                          }
                                          await product.doc(widget.id).update({
                                            'nameProduct': productName.text,
                                            'category': (category == null)
                                                ? widget.product.category
                                                : category,
                                            'price': double.tryParse(
                                                    priceProduct.text) ??
                                                0,
                                            'descItem': descItem.text,
                                            'protein':
                                                double.tryParse(proGram.text) ??
                                                    0,
                                            'calori':
                                                double.tryParse(calGram.text) ??
                                                    0,
                                            'fat':
                                                double.tryParse(fatGram.text) ??
                                                    0,
                                            'carbo':
                                                double.tryParse(carGram.text) ??
                                                    0,
                                            'imageUrl': imageUrl,
                                            'stock': int.tryParse(
                                                    stockController.text) ??
                                                0,
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
                              child: const Text('Save')),
                        )
                      : const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()),
                  const SizedBox(
                    height: 50,
                  )
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

  addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(1.0),
        child: SizedBox(
          height: 90.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              child: kIsWeb
                  ? Image.network(File(bytes.path).path)
                  : Image.file(
                      File(bytes.path),
                    ),
            ),
          ),
        ),
      ));
    }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage();
        photo!.clear();
      });
    }
  }

  upload() async {
    await uplaodImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    itemPhotosWidgetList.clear();
    showToast("Updated Data Product Successfully !",
        backgroundColor: Colors.green,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? productId = const Uuid().v4();
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, productId);
    }
    return productId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId) async {
    String? pId = const Uuid().v4();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('ProductImages/$productId/product_$pId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl!.add(value);
  }
}

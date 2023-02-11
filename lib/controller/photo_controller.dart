import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';

class PhotoController extends GetxController {
  List<Widget> itemPhotosWidgetList = <Widget>[].obs;
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  List<String>? downloadUrl = <String>[];
  List<String>? imageUrl = <String>[];
  var uploading = false.obs;
  String? pId = const Uuid().v4();

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
      itemImagesList = itemImagesList + photo!;
      addImage();
      photo!.clear();
    }
  }

  upload() async {
    await uplaodImageAndSaveItemInfo();
    uploading.value = false;
    itemPhotosWidgetList.clear();
    showToast("Updated Data Product Successfully !",
        backgroundColor: Colors.green,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    uploading.value = true;
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

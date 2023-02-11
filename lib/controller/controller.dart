import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var category = Rxn<String>();
  List<Widget> listAvalaible = <Widget>[].obs;
  RxList<Widget> avv = <Widget>[].obs;
  List<bool?> available = <bool?>[].obs;
  var isAvailable = Rxn<bool>();
  var isLogin = false.obs;
  var selectedIndex = 0.obs;
  var sortField = 'firstName'.obs;
  var isAscending = false.obs;
  var isOn = false.obs;
  var isDisable = false.obs;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }

  void getSort(String field) {
    sortField.value = field;
    isAscending.value = !isAscending.value;
  }
}

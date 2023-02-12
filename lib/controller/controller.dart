import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class Controller extends GetxController {
  var category = Rxn<String>();
  var isLogin = false.obs;
  var selectedIndex = 0.obs;
  var sortField = 'firstName'.obs;
  var isAscending = false.obs;
  var isOn = false.obs;
  var isDisable = false.obs;
  var isTake = false.obs;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }

  void getSort(String field) {
    sortField.value = field;
    isAscending.value = !isAscending.value;
  }

  toastInputNumber(String input) {
    showToast('Please Enter A Number Format For Input $input !',
        backgroundColor: Colors.red,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }
}

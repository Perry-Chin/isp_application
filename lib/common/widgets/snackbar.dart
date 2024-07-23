import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {

  static void successSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      isDismissible: true,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.check, color: Colors.white),
    );
  }

  static void errorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      isDismissible: true,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
}
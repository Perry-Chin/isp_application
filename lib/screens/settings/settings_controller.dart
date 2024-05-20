// settings_controller.dart

import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Add any required state variables and methods here
  var isDarkMode = false.obs;

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
  }
}

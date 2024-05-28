// Settings Bindings

import 'package:get/get.dart';

import '../profile/profile_index.dart';
import 'settingsx_index.dart';

class SettingsxBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<SettingsxController>(() => SettingsxController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }//1
}
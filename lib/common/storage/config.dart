import 'package:get/get.dart';

import '../values/values.dart';
import 'storage.dart';

class ConfigStore extends GetxController {
  static ConfigStore get to => Get.find();

  bool isFirstOpen = false;
  
  @override
  void onInit() {
    super.onInit();
    isFirstOpen = StorageService.to.getBool(device_first_open_key);
  }
  
  // Save that the user has opened the app
  Future<bool> saveAlreadyOpen() {
    return StorageService.to.setBool(device_first_open_key, true);
  }
}

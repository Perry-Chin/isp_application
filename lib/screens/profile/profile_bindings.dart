import 'package:get/get.dart';


import '../settingsx/settingsx_index.dart';
import 'profile_index.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<SettingsxController>(() => SettingsxController());
  }
}

import 'package:get/get.dart';

import 'profile_index.dart';

class NavbarBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
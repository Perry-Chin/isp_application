import 'package:get/get.dart';

import 'login_index.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
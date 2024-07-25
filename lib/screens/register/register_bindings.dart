import 'package:get/get.dart';

import 'register_index.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
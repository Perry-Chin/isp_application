import 'package:get/get.dart';

import 'home_index.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
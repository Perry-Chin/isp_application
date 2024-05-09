import 'package:get/get.dart';

import 'index.dart';

class RequestBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<RequestController>(() => RequestController());
  }
}
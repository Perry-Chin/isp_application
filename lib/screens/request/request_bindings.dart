// Request Service Bindings

import 'package:get/get.dart';

import 'request_index.dart';

class RequestBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<RequestController>(() => RequestController());
  }
}
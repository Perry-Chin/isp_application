// ignore_for_file: file_names

import 'package:get/get.dart';

import 'filterHome_index.dart';

class FilterHomeBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<FilterHomeController>(() => FilterHomeController());
  }
}
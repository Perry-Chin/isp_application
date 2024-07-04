import 'package:get/get.dart';

import 'detail_index.dart';

class DetailBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<DetailController>(() => DetailController());
  }
}

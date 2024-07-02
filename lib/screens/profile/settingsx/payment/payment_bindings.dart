import 'package:get/get.dart';

import 'payment_index.dart';

class PaymentBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}

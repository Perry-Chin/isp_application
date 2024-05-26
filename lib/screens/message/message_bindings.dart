import 'package:get/get.dart';

import 'message_index.dart';

class MessageBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<MessageController>(() => MessageController());
  }
}
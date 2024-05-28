import 'package:get/get.dart';

import 'chat_index.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
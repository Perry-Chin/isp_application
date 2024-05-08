import 'package:get/get.dart';
import 'controller.dart';

class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
import 'package:get/get.dart';
import '../home/index.dart';
import 'index.dart';

class NavbarBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NavbarController>(() => NavbarController());
  }
}
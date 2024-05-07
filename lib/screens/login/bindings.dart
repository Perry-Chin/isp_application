import 'package:get/get.dart';
import '../register/index.dart';
import 'index.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
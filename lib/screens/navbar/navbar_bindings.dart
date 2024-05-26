import 'package:get/get.dart';

import 'navbar_index.dart';
import '../home/home_index.dart';
import '../message/message_index.dart';
import '../profile/profile_index.dart';
import '../request/request_index.dart';
import '../schedule/schedule_index.dart';

class NavbarBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<RequestController>(() => RequestController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<MessageController>(() => MessageController());
  }
}

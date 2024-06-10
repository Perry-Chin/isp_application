import 'package:get/get.dart';

import 'schedule_index.dart';

class ScheduleBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}

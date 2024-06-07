import 'package:get/get.dart';

import 'filterSchedule/filterSchedule_index.dart';
import 'schedule_index.dart';

class ScheduleBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy initialization of controller to instantiate it only when needed.
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<FilterScheduleController>(() => FilterScheduleController());
  }
}
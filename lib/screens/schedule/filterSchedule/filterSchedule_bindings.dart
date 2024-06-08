import 'package:get/get.dart';

import '../schedule_index.dart';
import 'filterSchedule_index.dart';

class FilterScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<FilterScheduleController>(() => FilterScheduleController());
  }
}
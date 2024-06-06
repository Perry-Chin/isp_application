import 'package:get/get.dart';

import 'filterSchedule_index.dart';

class FilterScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilterScheduleController>(() => FilterScheduleController());
  }
}
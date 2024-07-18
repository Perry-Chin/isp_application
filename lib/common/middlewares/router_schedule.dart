import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../screens/schedule/schedule_index.dart';
import '../utils/utils.dart';

void updateFiltersAndNavigateBack() {
  // Read stored values
  List<dynamic>? storedStatusDynamic = GetStorage().read('selectedStatus');
  int? storedRating = GetStorage().read<int>('selectedRating');

  // Initialize the observables
  var selectedStatus = List<bool>.empty(growable: true).obs;
  int selectedRating = storedRating ?? 0;

  // Handle conversion and default values
  if (storedStatusDynamic != null) {
    selectedStatus.assignAll(storedStatusDynamic.map((e) => e as bool).toList());
  } else {
    selectedStatus.assignAll(List<bool>.filled(FilterStatus.filters.length, false));
  }

  // Generate selected status values
  final selectedStatusValue = FilterStatus.filters
    .asMap()
    .entries
    .where((entry) => selectedStatus.length > entry.key && selectedStatus[entry.key])
    .map((entry) => entry.value.status)
    .toList();

  // Store selected filters in GetStorage
  GetStorage().write('selectedStatus', selectedStatus.toList());
  GetStorage().write('selectedRating', selectedRating);

  // Pass selected status and rating to ScheduleController
  Get.find<ScheduleController>().filterServices(
    selectedStatus: selectedStatusValue,
    selectedRating: selectedRating + 0,
  );

  // Navigate back after updating
  Get.back();
}

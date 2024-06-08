
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/utils/utils.dart';
import '../schedule_index.dart';

class FilterScheduleController extends GetxController {
  final box = GetStorage();
  
  // Initialize selectedStatus with stored value from GetStorage
  var selectedStatus = List<bool>.filled(FilterService.filters.length, false).obs;
  var selectedRating = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved selections from GetStorage
    List<bool>? storedStatus = box.read('selectedStatus');
    int? storedRating = box.read('selectedRating');
    if (storedStatus != null) {
      selectedStatus.clear();
      selectedStatus.addAll(storedStatus);
    }
    if (storedRating != null) {
      selectedRating.value = storedRating;
    }
  }

  void toggleSelection(int index) {
    // Your existing toggleSelection logic remains the same...
    if (index == 0) {
      // If "All" is selected, deselect all others
      selectedStatus.fillRange(0, selectedStatus.length, false);
      selectedStatus[0] = true;
    } else {
      // If any other chip is selected, deselect "All"
      selectedStatus[0] = false;
      selectedStatus[index] = !selectedStatus[index];
    }
  }

  void resetSelection() {
    selectedStatus.fillRange(0, selectedStatus.length, false);
    selectedStatus[0] = true;
    selectedRating.value = 0;
    box.remove('selectedStatus');
    box.remove('selectedRating');
  }

  void setSelectedRating(int rating) {
    selectedRating.value = rating;
    box.write('selectedRating', rating);
  }

  void applyFilters() {
    final selectedStatusValue = FilterService.filters
        .asMap()
        .entries
        .where((entry) => selectedStatus[entry.key])
        .map((entry) => entry.value.status)
        .toList();

    // Store selected filters in GetStorage
    box.write('selectedStatus', selectedStatus);

    // Pass selected filters to ScheduleController
    Get.find<ScheduleController>().filterServices(
      selectedStatus: selectedStatusValue,
      selectedRating: selectedRating.value,
    );

    Get.back();
  }
}

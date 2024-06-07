// ignore_for_file: file_names

import 'package:get/get.dart';
import '../../../common/utils/utils.dart';
import '../schedule_index.dart';

class FilterScheduleController extends GetxController {
  var selected = List<bool>.filled(FilterService.filters.length, false).obs;
  var selectedCategory = ''.obs;
  var selectedRating = 0.obs; // Initialize selectedRating to 0

  void toggleSelection(int index) {
    if (index == 0) {
      // If "All" is selected, deselect all others
      selected.fillRange(0, selected.length, false);
      selected[0] = true;
    } else {
      // If any other chip is selected, deselect "All"
      selected[0] = false;
      selected[index] = !selected[index];
    }
  }

  void resetSelection() {
    selected.fillRange(0, selected.length, false);
    selectedRating.value = 0;

  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void setSelectedRating(int rating) {
    selectedRating.value = rating;
  }

  void applyFilters() {

    final selectedStatus = FilterService.filters
      .asMap()
      .entries
      .where((entry) => selected[entry.key])
      .map((entry) => entry.value.status)
      .toList();

     // Pass selected filters to ScheduleController
    Get.find<ScheduleController>().filterServices(
      selectedStatus: selectedStatus,
      selectedRating: selectedRating.value,
    );

    Get.back();
  }
}

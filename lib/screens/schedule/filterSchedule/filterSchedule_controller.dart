import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/utils/utils.dart';
import '../schedule_index.dart';

class FilterScheduleController extends GetxController {
  FilterScheduleController();
  final box = GetStorage();
  
  // Initialize selectedStatus with stored value from GetStorage
  var selectedStatus = List<bool>.empty(growable: true).obs; // Initialize as empty and growable
  var selectedRating = 0.obs;

  // To keep track of original selections before changes
  List<bool> originalSelectedStatus = [];
  int originalSelectedRating = 0;
  bool changesMade = false;

  @override
  void onInit() {
    super.onInit();
    // Load saved selections from GetStorage
    List<bool>? storedStatus = box.read('selectedStatus');
    int? storedRating = box.read('selectedRating');

    if (storedStatus != null) {
      selectedStatus.assignAll(storedStatus); // Assign stored status to observable list
      originalSelectedStatus = List.from(storedStatus); // Keep a copy of the original selections
    } else {
      // Initialize selectedStatus with false values if not stored
      selectedStatus.assignAll(List<bool>.filled(FilterStatus.filters.length, false));
    }

    if (storedRating != null) {
      selectedRating.value = storedRating;
      originalSelectedRating = storedRating; // Keep the original rating
    }
  }

  void toggleSelection(int index) {
    if (index >= 0 && index < selectedStatus.length) {
      selectedStatus[index] = !selectedStatus[index];
      changesMade = true;
    }
  }

  void resetSelection() {
    selectedStatus.assignAll(List<bool>.filled(selectedStatus.length, false));
    selectedRating.value = 0;
    box.remove('selectedStatus');
    box.remove('selectedRating');
    changesMade = true;
  }

  void revertChanges() {
    // Check if originalSelectedStatus is not empty and has the same length as selectedStatus
    if (originalSelectedStatus.isNotEmpty && originalSelectedStatus.length == selectedStatus.length) {
      selectedStatus.assignAll(originalSelectedStatus);
    } else {
      // Handle the case where originalSelectedStatus is empty or has a different length
      selectedStatus.assignAll(List<bool>.filled(selectedStatus.length, false));
    }
    
    selectedRating.value = originalSelectedRating;
    applyFilters();
  }


  void setSelectedRating(int rating) {
    selectedRating.value = rating;
    changesMade = true;
  }

  void applyFilters() {
    final selectedStatusValue = FilterStatus.filters
        .asMap()
        .entries
        .where((entry) => selectedStatus.length > entry.key && selectedStatus[entry.key])
        .map((entry) => entry.value.status)
        .toList();

    // Store selected filters in GetStorage
    box.write('selectedStatus', selectedStatus.toList());
    box.write('selectedRating', selectedRating.value);

    // Pass selected filters to ScheduleController
    Get.find<ScheduleController>().filterServices(
      selectedStatus: selectedStatusValue,
      selectedRating: selectedRating.value,
    );

    Get.back();
  }
}

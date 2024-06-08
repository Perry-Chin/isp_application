import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_application/common/widgets/widgets.dart';

import '../../../common/utils/utils.dart';
import '../../../common/values/values.dart';
import 'filterSchedule_index.dart';

class FilterSchedulePage extends GetView<FilterScheduleController> {
  const FilterSchedulePage({super.key});

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Filter"),
      backgroundColor: AppColor.secondaryColor,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          if(controller.changesMade) {
            _showConfirmationDialog(context);
          } else {
            controller.revertChanges();
          }
        },
      ),
      actions: [
        TextButton(
          child: const Text(
            "Reset", 
            style: TextStyle(color: Colors.white)
          ),
          onPressed: () {
            controller.resetSelection();
          },
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Changes?"),
          content: const Text("Do you want to save the changes before exiting?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                // Revert to old selections if user chooses 'No'
                controller.revertChanges(); // This will reload the stored values from GetStorage
                Get.back(); // Close the dialog
                Get.back(); // Close the filter page
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                // Save changes and exit if user chooses 'Yes'
                controller.applyFilters();
                Get.back(); // Close the dialog
                Get.back(); // Close the filter page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add the status filter
            CustomStatusFilter(filters: FilterStatus.filters),
            const SizedBox(height: 20),
            const Text(
              "Rating",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add the Star Rating
            Obx(() => StarRatingFilter(
              rating: controller.selectedRating.value,
              onChanged: (selectedRating) {
                controller.setSelectedRating(selectedRating ?? 0);
              },
            )),
            const Spacer(), // Add Spacer to push the button to the bottom
            ApplyButton(
              onPressed: () {
                controller.applyFilters();
              },
              buttonText: "Apply Filter", 
              buttonWidth: double.infinity,
              textAlignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomStatusFilter extends StatelessWidget {
  final List<FilterStatus> filters;
  const CustomStatusFilter({
    Key? key, 
    required this.filters
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final FilterScheduleController controller = Get.find();
    
    return Wrap(
      spacing: 10, // Horizontal spacing between the chips
      runSpacing: 10, // Vertical spacing between the lines
      children: filters.asMap().entries.map((entry) {
        int index = entry.key;
        FilterStatus filter = entry.value;
        return GestureDetector(
          onTap: () {
            controller.toggleSelection(index);
          },
          child: Obx(() {
            bool isSelected = controller.selectedStatus[index];
            return Chip(
              backgroundColor: isSelected ? filter.color : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: filter.color, width: 1),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : CircleAvatar(
                        radius: 8,
                        backgroundColor: filter.color,
                      ),
                  const SizedBox(width: 8),
                  Text(
                    filter.status,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}

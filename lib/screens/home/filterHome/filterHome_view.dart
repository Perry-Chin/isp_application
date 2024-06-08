import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/utils/utils.dart';
import '../../../common/values/values.dart';
import 'filterHome_index.dart';

class FilterHomePage extends GetView<FilterHomeController> {
  const FilterHomePage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text("Filter and Sort"),
      backgroundColor: AppColor.secondaryColor,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Get.back();
        },
      ),
      actions: [
        TextButton(
          child: const Text(
            "Reset", 
            style: TextStyle(color: Colors.white)
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CustomStatusFilter(filters: FilterService.filters),
            const SizedBox(height: 20),
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            // Additional categories or other widgets can be added here.
          ],
        ),
      ),
    );
  }
}

class CustomStatusFilter extends StatelessWidget {
  final List<FilterService> filters;
  const CustomStatusFilter({
    Key? key, 
    required this.filters
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10, // Horizontal spacing between the chips
      runSpacing: 10, // Vertical spacing between the lines
      children: filters
        .map((filter) => Chip(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey),
          ),
          label: Text(filter.status),
        ))
        .toList(),
    );
  }
}
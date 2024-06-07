import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    Key? key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10), // Reduced height for spacing
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding for dropdown menu
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: Colors.grey),
        //   ),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<String>(
        //       value: selectedCategory.isEmpty ? null : selectedCategory,
        //       isExpanded: true,
        //       icon: const Icon(Icons.arrow_drop_down),
        //       iconSize: 36, // Adjusted icon size for visibility
        //       elevation: 1, // Added elevation to dropdown menu
        //       style: const TextStyle(fontSize: 16, color: Colors.black),
        //       dropdownColor: Colors.white,
        //       onChanged: onChanged,
        //       items: categories.map((String category) {
        //         return DropdownMenuItem<String>(
        //           value: category,
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjusted padding
        //             child: Text(
        //               category,
        //               overflow: TextOverflow.ellipsis, // Prevent text clipping
        //               style: const TextStyle(fontSize: 16), // Adjusted text style if necessary
        //             ),
        //           ),
        //         );
        //       }).toList(),
        //     ),
        //   ),
        // ),
        DropdownButtonFormField<String>(
          hint: const Text('Select your favourite fruit'),
          value: selectedCategory.isEmpty ? null : selectedCategory,
          onChanged: onChanged,
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        )
      ],
    );
  }
}

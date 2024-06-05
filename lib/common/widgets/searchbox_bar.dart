import 'package:flutter/material.dart';

import '../values/values.dart';

class SearchBoxBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool showSuffixIcon;

  const SearchBoxBar({
    required this.controller,
    required this.onChanged,
    required this.showSuffixIcon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 1,
            offset: Offset(1.6, 1.6)
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor.secondaryColor,
          width: 1
        )
      ),
      child: Center(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColor.secondaryColor
            ),
            // Filter search results
            suffixIcon: showSuffixIcon
              ? IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: AppColor.secondaryColor,
                  ),
                  onPressed: () {
                    // Add your filter logic here
                  },
                )
              : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          controller: controller,
          onChanged: onChanged
        ),
      )
    );
  }
}
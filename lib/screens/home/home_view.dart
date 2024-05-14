import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import 'home_index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Home"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  // Search bar widget
  Widget searchBar() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE7EEF8),
            blurRadius: 1,
            offset: Offset(2.6, 2.6)
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
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: AppColor.secondaryColor,
              ),
              onPressed: () {
                
              },
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          // onChanged: searchElderly, // Callback for search
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            searchBar(),
            const SizedBox(height: 15),
            const SizedBox(
              height: 440,
              child: HomeList(),
            )
          ],
        )
      )
    );
  }
}
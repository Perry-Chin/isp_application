import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Container(
        height: 900,
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
        child: Column(
          children: [
            SearchBoxBar(
              controller: controller.searchController, 
              onChanged: (value) {
                // Call controller function to filter service list based on username
                controller.filterServiceList(value);
              },
              showSuffixIcon: true,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 470,
              child: HomeList(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import 'schedule_index.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({Key? key}) : super(key: key);

  // TabBar widget
  TabBar get _tabBar => TabBar(
    labelColor: AppColor.secondaryColor,
    indicatorColor: AppColor.secondaryColor,
    unselectedLabelColor: Colors.grey,
    controller: controller.tabController,
    tabs: const [
      Tab(text: 'Provided'),
      Tab(text: 'Requested'),
    ],
    onTap: (index) {
      controller.tabController.index = index;
    },
  );

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Schedule"),
      backgroundColor: AppColor.secondaryColor,
      bottom: PreferredSize(
        preferredSize: _tabBar.preferredSize,
        child: Material(
          color: AppColor.backgroundColor,
          child: _tabBar,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            Get.toNamed('/filterSchedule');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Obx(() {
            if (controller.tabController.index == 0) {
              return ProviderCard(
                selectedStatus: controller.selectedStatus,
                selectedRating: controller.selectedRating,
              );
            } else {
              return RequesterCard(
                selectedStatus: controller.selectedStatus,
                selectedRating: controller.selectedRating,
              );
            }
          }),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../common/values/values.dart';
import 'schedule_index.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text("Schedule"),
      backgroundColor: AppColor.secondaryColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Material(
          color: AppColor.secondaryColor,
          child: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            controller: controller.tabController,
            tabs: const [
              Tab(text: 'Provided'),
              Tab(text: 'Requested'),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // Redirect to filter page
            Get.toNamed('/filterSchedule')!.then((_) {
              // Update filter selections when returning from FilterSchedulePage
              controller.updateFilterFromStorage();
            });
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
          child: TabBarView(
            controller: controller.tabController,
            children: [
              GetBuilder<ScheduleController>(
                builder: (controller) {
                  return ProviderCard(
                    selectedStatus: controller.selectedStatus,
                    selectedRating: controller.selectedRating,
                  );
                },
              ),
              GetBuilder<ScheduleController>(
                builder: (controller) {
                  return RequesterCard(
                    selectedStatus: controller.selectedStatus,
                    selectedRating: controller.selectedRating,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

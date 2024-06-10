import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/values/values.dart';
import 'schedule_index.dart';
// import '../addreviews/addreviews_index.dart'; // Import the AddReviewPage

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({Key? key}) : super(key: key);

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Schedule",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
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
// schedule_view.dart
        IconButton(
          icon: const Icon(Icons.rate_review),
          onPressed: () {
            // Use named route navigation
            Get.toNamed('/addReviews');
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
        appBar: _buildAppBar(context),
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

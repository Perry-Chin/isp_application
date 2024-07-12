import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/custom/custom_theme.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'schedule_index.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({Key? key}) : super(key: key);

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
          const SizedBox(width: 8),
          Text(
            "Schedule",
            style: CustomTextTheme.darkTheme.labelMedium
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Material(
          color: AppColor.secondaryColor,
          child: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicator: const BoxDecoration(),
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            controller: controller.tabController,
            labelStyle: GoogleFonts.poppins(),
            tabs: const [
              Tab(text: 'Provided'),
              Tab(text: 'Requested'),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white,),
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
        backgroundColor: AppColor.secondaryColor,
        appBar: _buildAppBar(context),
        body: CustomContainer(
          child: Padding(
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
      ),
    );
  }
}

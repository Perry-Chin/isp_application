import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'home_index.dart';

class HomeList extends GetView<HomeController> {
  const HomeList({super.key});
  
  Widget homeListItem(QueryDocumentSnapshot<ServiceData> serviceItem, UserData? userData) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: InkWell(
        onTap: () {
          // Handle on tap
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.2),
          ),
          child: Column(
            children: [
              ListTile(
                horizontalTitleGap: 12,
                leading: CircleAvatar(
                  radius: 28.0,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/profile.png", // Placeholder image while loading
                      image: userData?.photourl ?? "", // Image URL
                      fadeInDuration: const Duration(milliseconds: 500), // Fade-in duration
                      fit: BoxFit.cover,
                      width: 54.w,
                      height: 54.w,
                      imageErrorBuilder: (context, error, stackTrace) => Image.asset("assets/images/profile.png"), // Error placeholder image
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      // Username of requester
                      Text(
                        userData?.username ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColor.secondaryColor),
                        ),
                        // Rating
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "4.5",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Date and time
                subtitle: Text(
                  "${serviceItem.data().date}, ${serviceItem.data().time}",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColor.secondaryColor,
                    ),
                    const SizedBox(width: 2),
                    Text(serviceItem.data().location ?? ""),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: serviceItem.data().serviceName!.length * 10.0,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          serviceItem.data().serviceName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\$${serviceItem.data().rate?.toString() ?? "0"}/h"
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a StreamBuilder to listen to the combined data stream from the controller
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        // Create a map to associate user data with service data based on the 'reqUserid'
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoading();
        }
        return Obx(
          () => SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller.refreshController,
            onLoading: controller.onLoading,
            onRefresh: controller.onRefresh,
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var serviceItem = controller.state.serviceList[index];
                        var userData = userDataMap[serviceItem.data().reqUserid];
                        return homeListItem(serviceItem, userData);
                      },
                      childCount: controller.state.serviceList.length
                    )
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }
}
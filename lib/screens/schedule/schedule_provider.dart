import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'schedule_index.dart';

class ProviderCard extends GetView<ScheduleController> {
  final List<String> selectedStatus;
  final int selectedRating;
  final token = UserStore.to.token;

   ProviderCard({
    Key? key,
    required this.selectedStatus,
    required this.selectedRating,
  }) : super(key: key);

  Widget providerListItem(
    QueryDocumentSnapshot<ServiceData> item,
    UserData? userData,
  ) {
    // Check if the item matches the selected filters
    if (!selectedStatus.contains('all') &&
        !selectedStatus.contains(item.data().status?.toLowerCase())) {
      return const SizedBox(); // Return an empty SizedBox if status doesn't match
    }

    if (selectedRating != 0) {
      // Filter based on rating
      final rating = userData?.rating ?? 0;
      if (selectedRating == 1 && rating > 3) {
        return const SizedBox(); // Return an empty SizedBox if rating doesn't match
      } else if (selectedRating == 2 && rating < 3) {
        return const SizedBox(); // Return an empty SizedBox if rating doesn't match
      }
    }


    Color statusColor = Colors.green; // Default green for "Finished"
    if (item.data().status?.toLowerCase() == 'requested') {
      statusColor = Colors.blue; // Change color based on status
    } else if (item.data().status?.toLowerCase() == 'cancelled') {
      statusColor = Colors.red;
    }

    return Card(
      elevation: 4, // Add elevation for a shadow effect
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
       child: InkWell(
        onTap: () {
          // Handle on tap
          var reqUserid = "";
          if(item.data().reqUserid == token) {
            reqUserid = item.data().reqUserid ?? "";
          }
          else {
            reqUserid = item.data().reqUserid ?? "";
          }
          Get.toNamed("/detail", parameters: {
            "doc_id": item.id,
            "req_uid": reqUserid
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.2),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 8.0, color: statusColor)
              )
            ),
            padding: const EdgeInsets.all(6), // Add padding inside the card
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 28.0,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: userData?.photourl != null && userData!.photourl!.isNotEmpty ?
                      FadeInImage.assetNetwork(
                        placeholder: "assets/images/profile.png",
                        image: userData.photourl ?? "",
                        fadeInDuration: const Duration(milliseconds: 100),
                        fit: BoxFit.cover,
                        width: 58.w,
                        height: 58.w,
                      ) :
                      Image.asset("assets/images/profile.png"),
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
                        // Rating
                        const Rating(rating: 8.5),
                      ],
                    ),
                  ),
                  // Date and time
                  subtitle: Text(
                    "${item.data().date}, ${item.data().time}",
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
                      Text(
                        item.data().location ?? "",
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: item.data().serviceName!.length * 11,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            item.data().serviceName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: item.data().status!.length * 11,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "${item.data().status}",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
       ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a StreamBuilder to listen to the combined data stream from the controller
    
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedProviderStream,
      builder: (context, snapshot) {
        // Create a map to associate user data with service data based on the 'requester_uid'
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoading();
        }
        return SmartRefresher(
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
                      var serviceItem = controller.state.providerList[index];
                      var userData = userDataMap[serviceItem.data().reqUserid];
                      return providerListItem(serviceItem, userData);
                    },
                    childCount: controller.state.providerList.length
                  )
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

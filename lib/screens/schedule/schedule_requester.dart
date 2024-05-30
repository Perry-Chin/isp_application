import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:isp_application/common/data/user.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';
import '../../common/data/service.dart';
import '../../common/data/user.dart';
// import '../../common/values/values.dart';
import '../../common/storage/user.dart';
import '../../common/values/color.dart';
import '../../common/widgets/shimmer.dart';
import 'schedule_index.dart';

// class RequesterProviderCards extends StatelessWidget{
//    final List<String> statusFilter;
//   final List<String> ratingFilter;

//   const RequesterProviderCards({Key? key, required this.statusFilter, required this.ratingFilter}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<RequesterCard> allProviderCards = [
//       const RequesterCard(rating: 4.5, starColor: Colors.white, status: 'finished'),
//       const RequesterCard(rating: 4.2, starColor: Colors.white, status: 'pending'),
//       const RequesterCard(rating: 3.9, starColor: Colors.white, status: 'cancelled'),
//       const RequesterCard(rating: 2, starColor: Colors.white, status: 'pending'),
//       // Add more ProviderCard widgets as needed
//     ];

//     List<RequesterCard> requesterProviderCards;

//     if (statusFilter.contains('all') && ratingFilter.contains('all')) {
//       // If both "all" status and "all" rating are selected, display all cards
//       requesterProviderCards = allProviderCards;
//     } else if (statusFilter.contains('all')) {
//       // If "all" status is selected, filter cards based on rating
//       requesterProviderCards = allProviderCards.where((card) {
//         return ratingFilter.contains('all') ||
//             ((ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
//                 (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3));
//       }).toList();
//     } else if (ratingFilter.contains('all')) {
//       // If "all" rating is selected, filter cards based on status
//       requesterProviderCards = allProviderCards.where((card) {
//         return statusFilter.contains('all') || statusFilter.contains(card.status.toLowerCase());
//       }).toList();
//     } else {
//       // Filter based on both status and rating filters
//       requesterProviderCards = allProviderCards.where((card) {
//         bool matchesStatus = statusFilter.contains(card.status.toLowerCase());
//         bool matchesRating =
//             (ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
//                 (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3);
//         return matchesStatus && matchesRating;
//       }).toList();
//     }

//     return ListView(
//       children: requesterProviderCards,
//     );
//   }
// }

class RequesterCard extends GetView<ScheduleController> {
  final List<String> selectedStatus;
  final List<String> selectedRating;
  final token = UserStore.to.token;

  RequesterCard({
    Key? key,
    required this.selectedStatus,
    required this.selectedRating,
  }) : super(key: key);

  Widget requesterListItem(
    QueryDocumentSnapshot<ServiceData> item,
    UserData? requesterData,
  ) {
    // Check if the item matches the selected filters
    if (!selectedStatus.contains('all') &&
        !selectedStatus.contains(item.data().status?.toLowerCase())) {
      return const SizedBox(); // Return an empty SizedBox if status doesn't match
    }

    if (!selectedRating.contains('all')) {
      // Filter based on rating
      final rating = requesterData?.rating ?? 0;
      if (selectedRating.contains('1 - 3') && rating > 3) {
        return const SizedBox(); // Return an empty SizedBox if rating doesn't match
      } else if (selectedRating.contains('3 - 5') && rating < 3) {
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
      margin: const EdgeInsets.all(16), // Add margin around the card
      child: InkWell(
        onTap: () {
          var reqUserid = "";
          if (item.data().reqUserid == token) {
            reqUserid = item.data().reqUserid ?? "";
          } else {
            reqUserid = item.data().reqUserid ?? "";
          }
          Get.toNamed("/detail", parameters: {
            "doc_id": item.id,
            "req_uid": reqUserid,
            "hide_buttons": "true" // Update parameter name to match detail_view
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(left: BorderSide(width: 10.0, color: statusColor))),
          padding: const EdgeInsets.all(16), // Add padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align children to the start of the column
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28.0,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder:
                            "assets/images/profile.png", // Placeholder image while loading
                        image: requesterData?.photourl ?? "", // Image URL
                        fadeInDuration: const Duration(
                            milliseconds: 500), // Fade-in duration
                        fit: BoxFit.cover,
                        width: 54.w,
                        height: 54.w,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                                "assets/images/profile.png"), // Error placeholder image
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(requesterData?.username ?? "",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 6),
                          RatedStar(
                              rating: requesterData?.rating ?? 0,
                              starColor: Colors.yellow),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text("${item.data().date?.toString() ?? " "},"),
                          const SizedBox(width: 3),
                          Text(item.data().time!),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 28, color: AppColor.secondaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("${item.data().location}",
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
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
                  ),
                  Container(
                    height: 43,
                    width: item.data().status!.length * 11,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Text(
                          "${item.data().status}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedRequesterStream,
      builder: (context, snapshot) {
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerLoading();
        }
        return Obx(
          () => SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller.refreshControllers,
            onLoading: controller.onLoadingControll,
            onRefresh: controller.onRefreshControll,
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var serviceItem =
                            controller.state.providerState.providerList[index];
                        var requesterData =
                            userDataMap[serviceItem.data().reqUserid];
                        return requesterListItem(serviceItem, requesterData);
                      },
                      childCount:
                          controller.state.providerState.providerList.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:isp_application/common/data/user.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';
import '../../common/data/service.dart';
// import '../../common/data/user.dart';
// import '../../common/values/values.dart';
import 'schedule_index.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({super.key});

  // final double rating;
  // final Color starColor;
  // final String status;

  // const ProviderCard({
  //   Key? key,
  //   required this.rating,
  //   required this.starColor,
  //   required this.status,
  // }) : super(key: key);

 Widget providerListItem(QueryDocumentSnapshot<ServiceData> item) {
  Color statusColor = Colors.green; // Default green for "Finished"
  if (item.data().status?.toLowerCase() == 'requested') {
    statusColor = Colors.blue; // Change color based on status
  } else if (item.data().status?.toLowerCase() == 'cancelled') {
    statusColor = Colors.red;
  }

  return Card(
    elevation: 4, // Add elevation for a shadow effect
    margin: const EdgeInsets.all(16), // Add margin around the card
    child: Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(width: 10.0, color: statusColor))),
      padding: const EdgeInsets.all(16), // Add padding inside the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle, size: 53, color: Colors.grey,),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bellaa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  RatedStar(rating: 3.5, starColor: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on, size: 28, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Text("${item.data().location}", overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: 200, // Adjust the width as needed
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text("${item.data().description}", overflow: TextOverflow.ellipsis, maxLines: 2),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 43,
                width: 110,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Text("${item.data().status}", style: const TextStyle(fontSize: 15, color: Colors.white),),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var controller = Get.find<ScheduleController>();
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
                    var item = controller.state.providerState.providerList[index];
                    return providerListItem(item);
                  },
                  childCount: controller.state.providerState.providerList.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}



// class FilteredProviderCards extends StatelessWidget{ 
//   final List<String> statusFilter;
//   final List<String> ratingFilter;

//   const FilteredProviderCards({Key? key, required this.statusFilter, required this.ratingFilter}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     if (statusFilter.contains('all') && ratingFilter.contains('all')) {
//       // If both "all" status and "all" rating are selected, display all cards
//       providerCards = allProviderCards;
//     } else if (statusFilter.contains('all')) {
//       // If "all" status is selected, filter cards based on rating
//       providerCards = allProviderCards.where((card) {
//         return ratingFilter.contains('all') ||
//             ((ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
//                 (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3));
//       }).toList();
//     } else if (ratingFilter.contains('all')) {
//       // If "all" rating is selected, filter cards based on status
//       providerCards = allProviderCards.where((card) {
//         return statusFilter.contains('all') || statusFilter.contains(card.status.toLowerCase());
//       }).toList();
//     } else {
//       // Filter based on both status and rating filters
//       providerCards = allProviderCards.where((card) {
//         bool matchesStatus = statusFilter.contains(card.status.toLowerCase());
//         bool matchesRating =
//             (ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
//                 (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3);
//         return matchesStatus && matchesRating;
//       }).toList();
//     }

//     return ListView(
//       children: providerCards,
//     );
//   }
// }

// Function to generate random ratings between minRating and maxRating
// double generateRandomRating({double minRating = 1.0, double maxRating = 5.0}) {
//   final random = Random();
//   return minRating + random.nextDouble() * (maxRating - minRating);
// }

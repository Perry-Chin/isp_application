import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';

import '../../common/data/service.dart';
import '../../common/data/user.dart';
// import '../../common/values/values.dart';
import 'schedule_index.dart';



class ProviderCard extends StatelessWidget {
  final double rating;
  final Color starColor;
  final String status;

  const ProviderCard({
    Key? key,
    required this.rating,
    required this.starColor,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green; // Default green for "Finished"
    if (status.toLowerCase() == 'pending') {
      statusColor = Colors.blue; // Change color based on status
    } else if (status.toLowerCase() == 'cancelled') {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 53, color: Colors.grey,),
                const SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Username",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        const SizedBox(width: 10,),
                        RatedStar(rating: rating, starColor: starColor),
                      ],
                    ),
                    const Text("10:00am - 9:00am"),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.location_on,size: 28,color: Colors.grey,),
                SizedBox(width: 10,),
                Text("Balam Road"),
              ],
            ),

            const SizedBox(height: 15,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Light Housekeeping"),
                  ),
                ),

                const SizedBox(
                  width: 35,
                ),

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
                      child: Text(status,style: const TextStyle(fontSize: 15, color: Colors.white),),
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
}

class FilteredProviderCards extends GetView<ScheduleController> {
  final List<String> statusFilter;
  final List<String> ratingFilter;

  const FilteredProviderCards({Key? key, required this.statusFilter, required this.ratingFilter}) : super(key: key);

  List<ProviderCard> filteredProviderlist(QueryDocumentSnapshot<ServiceData> item, QueryDocumentSnapshot<UserData> rating) {
    List<ProviderCard> allProviderCards = [
      ProviderCard(rating: rating.data().rating!, starColor: Colors.white, status: item.data().status!),
    ];

    print("Filtering cards: ${allProviderCards.length}");

    // Temporarily disable filtering to check if cards are shown
    // List<ProviderCard> filteredProviderCards = allProviderCards;

    List<ProviderCard> filteredProviderCards;

    if (statusFilter.contains('all') && ratingFilter.contains('all')) {
      filteredProviderCards = allProviderCards;
    } else if (statusFilter.contains('all')) {
      filteredProviderCards = allProviderCards.where((card) {
        return ratingFilter.contains('all') ||
            ((ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
                (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3));
      }).toList();
    } else if (ratingFilter.contains('all')) {
      filteredProviderCards = allProviderCards.where((card) {
        return statusFilter.contains('all') || statusFilter.contains(card.status.toLowerCase());
      }).toList();
    } else {
      filteredProviderCards = allProviderCards.where((card) {
        bool matchesStatus = statusFilter.contains(card.status.toLowerCase());
        bool matchesRating =
            (ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
                (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3);
        return matchesStatus && matchesRating;
      }).toList();
    }

    print("Filtered cards: ${filteredProviderCards.length}");

    return filteredProviderCards;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.state.providerState.providerList.isEmpty) {
          return Center(child: CircularProgressIndicator());
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
                      // Check if both lists have the same length
                      if (index >= controller.state.ratingState.ratingState.length) {
                        print("Index out of range: providerList length = ${controller.state.providerState.providerList.length}, ratingState length = ${controller.state.ratingState.ratingState.length}");
                        return SizedBox.shrink(); // Return an empty widget if index is out of range
                      }

                      var item = controller.state.providerState.providerList[index];
                      var rating = controller.state.ratingState.ratingState[index];
                      var filteredCards = filteredProviderlist(item, rating);
                      return Column(
                        children: filteredCards,
                      );
                    },
                    childCount: controller.state.providerState.providerList.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

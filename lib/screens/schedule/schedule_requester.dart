// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
// import 'package:get/get.dart';

// import '../../common/data/service.dart';
// import '../../common/data/user.dart';
// import '../../common/values/values.dart';
import 'schedule_index.dart';

class RequesterProviderCards extends StatelessWidget{ 
   final List<String> statusFilter;
  final List<String> ratingFilter;

  const RequesterProviderCards({Key? key, required this.statusFilter, required this.ratingFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RequesterCard> allProviderCards = [
      const RequesterCard(rating: 4.5, starColor: Colors.white, status: 'finished'),
      const RequesterCard(rating: 4.2, starColor: Colors.white, status: 'pending'),
      const RequesterCard(rating: 3.9, starColor: Colors.white, status: 'cancelled'),
      const RequesterCard(rating: 2, starColor: Colors.white, status: 'pending'),
      // Add more ProviderCard widgets as needed
    ];

    List<RequesterCard> requesterProviderCards;

    if (statusFilter.contains('all') && ratingFilter.contains('all')) {
      // If both "all" status and "all" rating are selected, display all cards
      requesterProviderCards = allProviderCards;
    } else if (statusFilter.contains('all')) {
      // If "all" status is selected, filter cards based on rating
      requesterProviderCards = allProviderCards.where((card) {
        return ratingFilter.contains('all') ||
            ((ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
                (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3));
      }).toList();
    } else if (ratingFilter.contains('all')) {
      // If "all" rating is selected, filter cards based on status
      requesterProviderCards = allProviderCards.where((card) {
        return statusFilter.contains('all') || statusFilter.contains(card.status.toLowerCase());
      }).toList();
    } else {
      // Filter based on both status and rating filters
      requesterProviderCards = allProviderCards.where((card) {
        bool matchesStatus = statusFilter.contains(card.status.toLowerCase());
        bool matchesRating =
            (ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
                (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3);
        return matchesStatus && matchesRating;
      }).toList();
    }

    return ListView(
      children: requesterProviderCards,
    );
  }
}




class RequesterCard extends StatelessWidget {
  final double rating;
  final Color starColor;
  final String status;



  const RequesterCard({
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
            ],)
          ],
        ),
      ),
    );
  }
}

class RequesterCards extends StatelessWidget {
  const RequesterCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        RequesterCard(rating: 4.5, starColor: Colors.white, status: "pending"),
        RequesterCard(rating: 4.2, starColor: Colors.white, status: "cancelled"),
        RequesterCard(rating: 3.9, starColor: Colors.white, status: "pending"),
        // Add more ProviderCard widgets as needed
      ],
    );
  }
}

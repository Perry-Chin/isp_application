import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/color.dart';
import 'detail_index.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage(BuildContext buildContext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<DetailController>(
        init: DetailController(), // Initialize the controller
        builder: (controller) {
          return SingleChildScrollView(
            // Make the content scrollable
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Confirm your booking",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Once submitted, BuzzBuddy will send a confirmation to both parties for service to be carried out.",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Date & Time",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(
                        16.0), // Set padding for the container
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius
                      color: Colors.grey[200], // Set background color
                    ),
                    child: const Text(
                      'Your original date and time here',
                      style: TextStyle(
                        fontSize: 16.0, // Set font size
                        color: Colors.black, // Set text color
                      ),
                    ),
                  ),
                  const Text(
                    "Total fees",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(
                        16.0), // Set padding for the container
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius
                      color: Colors.grey[200], // Set background color
                      border: Border.all(
                        // Add border
                        color: Colors.black, // Set border color
                        width: 1.0, // Set border width
                      ),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Payout: '),
                            Text('SGD 40.00'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Fee Breakdown',
                              style: TextStyle(color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.togglePaymentSection(); // Toggle visibility
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: controller.showPaymentSection,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5, top: 5, bottom: 10),
                                child: Text(
                                  "Total Fees",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment Method",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                "assets/images/paynow.png"),
                                            width: 24,
                                            height: 24,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "PayNow",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Requester',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(Icons.person, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Username',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  RatedStar(
                                      rating: 3.5, starColor: Colors.yellow),
                                ],
                              ),
                              Text(
                                'user@mail.com',
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the radius as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(
                            44, 68, 138, 1.0), // Text color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RatedStar extends StatelessWidget {
  final double rating;
  final Color starColor;
  final double iconSize;

  const RatedStar({
    Key? key,
    required this.rating,
    required this.starColor,
    this.iconSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 5), // Match the padding
      decoration: BoxDecoration(
        color: Colors.white, // Set background color to white
        borderRadius: BorderRadius.circular(20), // Adjust the border radius
        border: Border.all(
            color: AppColor
                .secondaryColor), // Use your AppColor.secondaryColor here
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rating',
            style: const TextStyle(
              fontSize: 14, // Adjust the font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 3), // Add spacing between rating and star icon
          Icon(
            Icons.star,
            color: starColor,
            size: iconSize,
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/data/data.dart';
import '../detail_index.dart';

class ServiceDetail extends StatelessWidget {
  const ServiceDetail({
    super.key,
    required this.serviceData,
    required this.hideButtons,
  });

  final ServiceData serviceData;
  final bool hideButtons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            detail(serviceData, hideButtons)
          ],
        ),
      ),
    );
  }

  Widget detail(ServiceData serviceData, bool hideButtons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: hideButtons ? 40 : 120,
                width: 40,
                child: const Icon(Icons.date_range),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceData.date ?? "Description",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${serviceData.starttime} - ${serviceData.endtime}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10,),
                  GetBuilder(builder: )
                 FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('service')
                      .doc(serviceData.serviceid)
                      .collection('propose')
                      .limit(1)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("Loading");
                      return const SizedBox.shrink();
                    }

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      print("snapshot.hasData");
                      final proposeDoc = snapshot.data!.docs.first;
                      final startTime = proposeDoc.get('start_time') as String?;
                      if (startTime != null) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Text(
                            "Proposed time is: $startTime",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }
                    }

                    return const SizedBox.shrink();
                  },
                ),

                    //     if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    //       // print(serviceData.serviceid);
                    //       final data = snapshot.data!.docs.first;
                    //       final startTime = data["start_time"];
                    //       // print(startTime);
                    //       if (startTime != null) {
                    //         return Padding(
                    //           padding: const EdgeInsets.only(bottom: 8),
                    //           child: Text(
                    //             "Your proposed time: $startTime",
                    //             style: const TextStyle(
                    //               fontStyle: FontStyle.italic,
                    //               color: Colors.blue,
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //     }

                    //     return const SizedBox.shrink();
                    //   },
                    // ),

                  if (!hideButtons) ...[
                    const SizedBox(height: 10),
                    const Text(
                      "Unavailable at this time?",
                      style: TextStyle(fontSize: 15, color: Color(0xFFCE761D)),
                    ),
                    const SizedBox(height: 8),
                    proposeNewTimeButton(),
                  ],
                ],
              ),
            ],
          ),
          const Divider(
            thickness: 2,
            color: Colors.black12,
            height: 35,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 25,
                width: 40,
                child: const Icon(Icons.location_on),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  serviceData.location ?? "Description",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget proposeNewTimeButton() {
    return ElevatedButton(
      onPressed: () {
        proposeNewPage(Get.context!); // Make sure to pass the context
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 4, // Small shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.black, width: 0.5),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10), // Set padding
        child: const Row(
          children: [
            Icon(Icons.alarm, color: Colors.black),
            SizedBox(width: 8),
            Text(
              "Propose a new time",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

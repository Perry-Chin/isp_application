import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/data/data.dart';
import '../detail_index.dart';

class ServiceDetail extends StatelessWidget {
  const ServiceDetail({
    Key? key,
    required this.controller,
    required this.serviceData,
    required this.hideButtons,
  }) : super(key: key);

  final DetailController controller;
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
            Text(
              "Details",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            detail(serviceData, hideButtons, controller),
          ],
        ),
      ),
    );
  }

  Widget detail(ServiceData serviceData, bool hideButtons, DetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('service')
                .doc(serviceData.serviceid)
                .collection('propose')
                .limit(1)
                .get(),
            builder: (context, snapshot) {
              double containerHeight;
              if (serviceData.status == "Requested" && serviceData.reqUserid != controller.token) {
                containerHeight = 140;
              } else if (serviceData.status == "Pending" && snapshot.data?.docs.length == 1) {
                containerHeight = 85;
              } else {
                containerHeight = 55;
              }
              return Row(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: containerHeight,
                    width: 40,
                    child: const Icon(Icons.date_range),
                  ),
                  const SizedBox(width: 10),
                  dateTimeContent(serviceData, hideButtons, controller, snapshot),
                ],
              );
            },
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
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateTimeContent(ServiceData serviceData, bool hideButtons, DetailController controller, snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          serviceData.date ?? "Description",
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        const SizedBox(height: 10),
        Text(
          "${serviceData.starttime} - ${serviceData.endtime}",
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        if (!hideButtons && serviceData.status == "Requested") ...[
          const SizedBox(height: 10),
          Text(
            "Unavailable at this time?",
            style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFFCE761D)),
          ),
          const SizedBox(height: 8),
          proposeNewTimeButton(),
        ],
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            "Proposed time: ${snapshot.data!.docs.first['start_time']}",
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.blue,
            ),
          )
        ]
      ],
    );
  }

  Widget proposeNewTimeButton() {
    return ElevatedButton(
      onPressed: () {
        proposeNewPage(Get.context!);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Container(
        width: 171,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.alarm, color: Colors.black),
            const SizedBox(width: 8),
            Flexible(  // Wrapped in Flexible
              child: Text(
                "Propose a new time",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
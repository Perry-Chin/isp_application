import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'detail_index.dart';

class DetailPage extends GetView<DetailController> {
  DetailPage({super.key});
  final imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      bottomNavigationBar: applyButton(),
      body: FutureBuilder<void>(
        future: controller.asyncLoadAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return content(context);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget content(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width - 133,
                  child: Obx(() {
                    if (controller.state.serviceList.isNotEmpty) {
                      var serviceData = controller.state.serviceList.first.data();
                      return backgroundImage(serviceData);
                    }
                    return const SizedBox.shrink();
                  }),
                ),
              ),
              buttonArrow(context),
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.width - 150,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          buildContent(context)
        ],
      ),
    );
  }

  Widget backgroundImage(ServiceData serviceData) {
    if (controller.state.serviceList.isNotEmpty) {
      if (serviceData.image != null && serviceData.image!.isNotEmpty) {
        // Load image using photourl
        return SizedBox(
          width: double.infinity,
          child: Image.network(
            serviceData.image!,
            fit: BoxFit.cover,
          ),
        );
      } else {
        // Check service name for default image
        if (serviceData.serviceName != null) {
          // Load image based on service name
          switch (serviceData.serviceName) {
            case 'Grooming':
              return Image.asset(
                'assets/images/grooming.jpg',
                width: double.infinity,
                fit: BoxFit.cover,
              );
            case 'Walking':
              return Image.asset(
                'assets/images/walking.jpeg',
                width: double.infinity,
                fit: BoxFit.cover,
              );
            // Add cases for other service names if needed
            default:
              // Default image if service name doesn't match predefined cases
              return Image.asset(
                'assets/images/walking.jpeg',
                width: double.infinity,
                fit: BoxFit.cover,
              );
          }
        }
      }
    }
    // Return a default image widget if no conditions are met
    return Image.asset(
      'assets/images/walking.jpeg',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget buttonArrow(BuildContext context) {
    return Positioned(
      top: 25,
      left: 15,
      child: Opacity(
        opacity: 0.6,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var serviceData = controller.state.serviceList.first.data();
          var reqUserId = serviceData.reqUserid;
          var userData = snapshot.data![reqUserId];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topIndicator(),
              serviceName(serviceData.serviceName),
              serviceDetailsCard(serviceData),
              serviceDescription(serviceData.description),
              requesterInfo(userData),
              feeInfo(userData),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget topIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 5,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }

  Widget serviceName(String? name) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 5),
      child: Text(
        name ?? "Service Name",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
      ),
    );
  }

  Widget serviceDetailsCard(ServiceData serviceData) {
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
            detail(serviceData),
          ],
        ),
      ),
    );
  }

  Widget serviceDescription(String? description) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description ?? "Description",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(
            thickness: 2,
            color: Colors.black12,
            height: 35,
          ),
        ],
      ),
    );
  }

  Widget requesterInfo(UserData? userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 5),
          child: Text(
            "Meet the Requester",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 28.0,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/profile.png",
                image: userData?.photourl ?? "",
                fadeInDuration: const Duration(milliseconds: 500),
                fit: BoxFit.cover,
                width: 54.w,
                height: 54.w,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/images/profile.png"),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                Text(
                  userData?.username ?? "Username",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                userRating(),
              ],
            ),
          ),
          subtitle: Text(userData?.email ?? ""),
        ),
        actionButtons(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            thickness: 2,
            color: Colors.black12,
            height: 35,
          ),
        ),
      ],
    );
  }

  Widget feeInfo(UserData? userData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, top: 5, bottom: 10),
              child: Text(
                "Total Fees",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final taxFee = controller.taxFee.value;
                final subtotal = controller.subtotal.value;
                final totalCost = controller.totalCost.value;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal"),
                        Text("\$$subtotal")
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tax Fee"),
                        Text("\$$taxFee")
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total"),
                        Text(
                          "\$$totalCost",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                      color: Colors.black12,
                      height: 15,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Payment Method",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image(
                                    image: const AssetImage("assets/images/paynow.png"),
                                    width: 24.w,
                                    height: 24.w,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "PayNow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget applyButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: ApplyButton(
                // button.dart
                onPressed: () {},
                buttonText: "Apply Now",
                buttonWidth: 100),
          ),
        ],
      ),
    );
  }

  Widget userRating() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.secondaryColor),
      ),
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
    );
  }

  Widget actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // View reviews action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4, // Small shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15), // Set padding
                child: const Text(
                  "View reviews",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Chat action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4, // Small shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15), // Set padding
                child: const Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detail(ServiceData serviceData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 120,
                width: 40,
                child: const Icon(Icons.date_range),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceData.date ?? "Description",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    serviceData.time ?? "Description",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Unavailable at this time?",
                    style: TextStyle(fontSize: 15, color: Color(0xFFCE761D)),
                  ),
                  const SizedBox(height: 8),
                  proposeNewTimeButton(),
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
              Text(
                serviceData.location ?? "Description",
                style: const TextStyle(fontSize: 15),
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
        // View reviews action
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'confirmpg.dart';
import 'detail_index.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {

    bool hideButtons = Get.parameters['hide_buttons'] == 'true';
    // String requested = Get.parameters['requested']!;
    // String status = Get.parameters['status']!;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      bottomNavigationBar: hideButtons ? null : applyButton(context),
      body: FutureBuilder<void>(
        future: controller.asyncLoadAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return content(context, hideButtons);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget content(BuildContext context, bool hideButtons) {
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
                      var serviceData =
                          controller.state.serviceList.first.data();
                      return BackgroundImage(controller: controller, serviceData: serviceData);
                    }
                    return const SizedBox.shrink();
                  }),
                ),
              ),
              BackArrow(context: context),
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
          buildContent(context, hideButtons)
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context, bool hideButtons) {
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var serviceData = controller.state.serviceList.first.data();
          var reqUserId = serviceData.reqUserid;
          var provUserId = serviceData.provUserid;
          var reqUserData = snapshot.data![reqUserId];
          var provUserData = snapshot.data![provUserId];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopIndicator(),
              DetailTitle(name: serviceData.serviceName),
              ServiceDetail(serviceData: serviceData, hideButtons: hideButtons),
              ServiceDescription(description: serviceData.description),
              if (Get.parameters['requested'] != "true")
                RequesterInfo(controller: controller, userData: reqUserData, hideButtons: hideButtons),
              if (Get.parameters['requested'] == "true" && provUserData != null)
                ProviderInfo(controller: controller, userData: provUserData, hideButtons: hideButtons),
              FeeInfo(controller: controller, userData: reqUserData), 
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget applyButton(BuildContext context) {
    String? status = Get.parameters['status'];
    String? requested = Get.parameters['requested'];
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: getButtonBasedOnStatus(status: status, requested: requested),
          ),
          if ((status == "Pending" || status == "Booked") && requested == "true") ...[
            const SizedBox(width: 10),
            if (status == "Booked") ...[
              Expanded(
                flex: 6,
                child: CancelButton(
                  onPressed: () => controller.updateServiceStatus(controller.doc_id, "Cancelled", 5),
                  buttonText: "Cancel Service",
                  buttonWidth: 135
                )
              ),
            ],
            if (status == "Pending") ...[
              Expanded(
                flex: 6,
                child: CancelButton(
                  onPressed: () => controller.updateServiceStatus(controller.doc_id, "Requested", 4),
                  buttonText: "Deny Request",
                  buttonWidth: 130
                )
              ),
            ],  
          ] 
        ],
      ),
    );
  }

  Widget getButtonBasedOnStatus({
    required String? status,
    required String? requested
  }) {
    if (status == "Pending" && requested == "true") {
      return ApplyButton(
        onPressed: () => controller.updateServiceStatus(controller.doc_id, "Booked", 3),
        buttonText: "Accept Request",
        buttonWidth: 145,
      );
    } else if (status == "Booked" && requested == "true") {
      return ApplyButton(
        onPressed: () => controller.updateServiceStatus(controller.doc_id, "Started", 1),
        buttonText: "Start Service",
        buttonWidth: 120,
      );
    } else if (status == "Started" && requested == "true") {
      return ApplyButton(
        onPressed: () => controller.updateServiceStatus(controller.doc_id, "Completed", 5),
        buttonText: "Complete Service",
        buttonWidth: 160,
      );
    } else {
      return ApplyButton(
        onPressed: () => confirmpg(Get.context!),
        buttonText: "Apply Now",
        buttonWidth: 100,
      );
    }
  }
}

class ServiceDescription extends StatelessWidget {
  const ServiceDescription({
    super.key,
    required this.description,
  });

  final String? description;

  @override
  Widget build(BuildContext context) {
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
}

class BackArrow extends StatelessWidget {
  const BackArrow({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.controller,
    required this.serviceData,
  });

  final DetailController controller;
  final ServiceData serviceData;

  @override
  Widget build(BuildContext context) {
    if (controller.state.serviceList.isNotEmpty) {
      String? imageUrl = serviceData.image;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Load image using photourl
        return SizedBox(
          width: double.infinity,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/default_image.jpeg', // Default image asset
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        );
      } else if (serviceData.serviceName != null) {
        // Check service name for default image
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
              'assets/images/walking.jpeg', // Default image asset
              width: double.infinity,
              fit: BoxFit.cover,
            );
        }
      }
    }
    // Return a default image widget if no conditions are met
    return Image.asset(
      'assets/images/default_image.jpeg', // Default image asset
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
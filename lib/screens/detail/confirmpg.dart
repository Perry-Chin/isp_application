// Confirmation of Booking Page

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/routes/routes.dart';
import '../../common/storage/storage.dart';
import '../../common/widgets/widgets.dart';
import '../home/home_controller.dart';
import 'detail_index.dart';

Future confirmpg(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bc) {
      return const ConfirmPage();
    },
    backgroundColor: AppColor.backgroundColor
  );
}

class ConfirmPage extends GetView<DetailController> {
  const ConfirmPage({Key? key}) : super(key: key);

   void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(AppText.confirmationTitle),
        content: const Text(AppText.confirmationSubtitle),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () async {
              // Update provUserid in ServiceData
              final currentUserId =
                  UserStore.to.token; // Assuming token is current user ID
              final serviceId = controller.doc_id;
              if (serviceId != null) {
                await controller.updateServiceProvUserid(
                    serviceId, currentUserId);
                // Update status to "Pending"
                await controller.bookServiceStatus(serviceId, "Pending", 1);
              }
              Navigator.of(context).pop(); // Dismiss the dialog
              Get.offAllNamed(AppRoutes.navbar); // Navigate to home page and remove all previous routes
              Get.find<HomeController>().onRefresh(); // Call refreshData on HomeController
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Material(
        child: SafeArea(
          child: GetBuilder<DetailController>(
            builder: (controller) {
              return SingleChildScrollView(
                child: Container(
                  color: AppColor.backgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const TopIndicator(),
                            const SizedBox(height: 8),
                            const Center(
                              child: Text(
                                "Confirm your booking",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Once submitted, FurFriends will send a confirmation to both parties for service to be carried out.",
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Date & Time",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            DatetimeField(controller: controller),
                            const SizedBox(height: 15),
                            const Text(
                              "Total fees",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            PaymentDetail(controller: controller),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      RequesterInfo(
                        controller: controller, 
                        userData: controller.userData.value,
                        hideButtons: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: ApplyButton(
                                // button.dart
                                onPressed: () {
                                  _showConfirmationDialog(context);
                                },
                                buttonText: "Continue",
                                buttonWidth: double.infinity,
                                textAlignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
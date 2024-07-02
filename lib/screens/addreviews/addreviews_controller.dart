import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/values/values.dart';

class CompletedService {
  final String id;
  final String serviceName;
  final String providerUid;
  final String requesterUid;
  final String role;

  CompletedService({
    required this.id,
    required this.serviceName,
    required this.providerUid,
    required this.requesterUid,
    required this.role,
  });
}

class AddReviewController extends GetxController {
  final selectedServiceId = ''.obs;
  final role = ''.obs;
  final rating = 0.obs;
  final reviewDescriptionController = TextEditingController();
  final completedServices = <CompletedService>[].obs;

  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    print("AddReviewController initialized"); // Debug print
    print(
        "Current user: ${FirebaseAuth.instance.currentUser?.uid}"); // Debug print
    loadCompletedServices();
  }

  void loadCompletedServices() async {
    print("Loading completed services"); // Debug print
    print(
        "Current user: ${FirebaseAuth.instance.currentUser?.uid}"); // Debug print
    try {
      // Fetch all services
      QuerySnapshot allServicesSnapshot = await db.collection('services').get();

      print("All services: ${allServicesSnapshot.docs.length}"); // Debug print

      // Print details of all services
      for (var doc in allServicesSnapshot.docs) {
        print("Service ID: ${doc.id}");
        print("Service Name: ${doc['service_name']}");
        print("Status: ${doc['status']}");
        print("Requester UID: ${doc['requester_uid']}");
        print("Provider UID: ${doc['provider_uid']}");
        print("------------------------");
      }

      print("Querying with status: Completed");
      print("Querying with requester_uid: ${currentUser!.uid}");

      // More general query for requester services
      QuerySnapshot requesterServicesSnapshot = await db
          .collection('services')
          .where('requester_uid', isEqualTo: currentUser!.uid)
          .where('status', isEqualTo: 'Completed')
          .get();

      print(
          "Requester services (completed): ${requesterServicesSnapshot.docs.length}"); // Debug print

      // More general query for provider services
      QuerySnapshot providerServicesSnapshot = await db
          .collection('services')
          .where('provider_uid', isEqualTo: currentUser!.uid)
          .where('status', isEqualTo: 'Completed')
          .get();

      print(
          "Provider services (completed): ${providerServicesSnapshot.docs.length}"); // Debug print

      List<CompletedService> services = [];

      for (var doc in requesterServicesSnapshot.docs) {
        services.add(CompletedService(
          id: doc.id,
          serviceName: doc['service_name'],
          providerUid: doc['provider_uid'],
          requesterUid: doc['requester_uid'],
          role: 'requester',
        ));
      }

      for (var doc in providerServicesSnapshot.docs) {
        services.add(CompletedService(
          id: doc.id,
          serviceName: doc['service_name'],
          providerUid: doc['provider_uid'],
          requesterUid: doc['requester_uid'],
          role: 'provider',
        ));
      }

      completedServices.assignAll(services);

      if (completedServices.isNotEmpty) {
        selectedServiceId.value = completedServices[0].id;
        role.value = completedServices[0].role;
      }

      print(
          "Completed services loaded: ${completedServices.length}"); // Debug print
    } catch (e, stackTrace) {
      print("Error loading completed services: $e"); // Debug print
      print("Stack trace: $stackTrace"); // Debug print
    }
  }

  void updateSelectedService(String serviceId) {
    print("Updating selected service to: $serviceId"); // Debug print
    selectedServiceId.value = serviceId;
    CompletedService selectedService = completedServices.firstWhere(
      (service) => service.id == serviceId,
    );
    role.value = selectedService.role;
    print("Updated role: ${role.value}"); // Debug print
  }

  void addReview(BuildContext context) async {
    print("Adding review"); // Debug print
    print("Selected service ID: ${selectedServiceId.value}"); // Debug print
    print("Rating: ${rating.value}"); // Debug print
    print("Review text: ${reviewDescriptionController.text}"); // Debug print

    if (reviewDescriptionController.text.isEmpty ||
        rating.value == 0 ||
        selectedServiceId.value.isEmpty) {
      showRoundedErrorDialog(context, 'Please complete all fields.');
      return;
    }

    CompletedService selectedService = completedServices.firstWhere(
      (service) => service.id == selectedServiceId.value,
    );

    String toUid = selectedService.role == 'requester'
        ? selectedService.providerUid
        : selectedService.requesterUid;

    try {
      await db.collection('reviews').add({
        'from_uid': currentUser!.uid,
        'to_uid': toUid,
        'service_id': selectedServiceId.value,
        'service_type': role.value,
        'review_text': reviewDescriptionController.text,
        'rating': rating.value,
        'timestamp': Timestamp.now(),
      });

      print("Review added successfully"); // Debug print
      Get.back();
      Get.snackbar('Success', 'Review added successfully');
    } catch (e) {
      print("Error adding review: $e"); // Debug print
      showRoundedErrorDialog(context, 'Error adding review: $e');
    }
  }

  void showRoundedErrorDialog(BuildContext context, String message) {
    print("Showing error dialog: $message"); // Debug print
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(AppText.error),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(AppText.confirmation),
          ),
        ],
      ),
    );
  }
}

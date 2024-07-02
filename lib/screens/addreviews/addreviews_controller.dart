import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/storage/storage.dart';
import '../../common/values/values.dart';

class AddReviewController extends GetxController {
  final selectedServiceId = ''.obs;
  final role = ''.obs;
  final rating = 0.obs;
  final reviewDescriptionController = TextEditingController();
  final completedServices = <Map<String, dynamic>>[].obs;
  final isReviewTextBoxFocused = false.obs;

  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadCompletedServices();
  }

  void loadCompletedServices() async {
    try {
      var requesterServicesSnapshot = await db
          .collection('service')
          .where('requester_uid', isEqualTo: token)
          .where('status', isEqualTo: 'Completed')
          .get();

      QuerySnapshot providerServicesSnapshot = await db
          .collection('service')
          .where('provider_uid', isEqualTo: token)
          .where('status', isEqualTo: 'Completed')
          .get();

      List<Map<String, dynamic>> services = [];

      for (var doc in requesterServicesSnapshot.docs) {
        if (!(await hasReviewed(doc.id, 'requester'))) {
          services.add({
            'id': doc.id,
            'serviceName': doc['service_name'],
            'providerUid': doc['provider_uid'],
            'requesterUid': doc['requester_uid'],
            'role': 'requester',
          });
        }
      }

      for (var doc in providerServicesSnapshot.docs) {
        if (!(await hasReviewed(doc.id, 'provider'))) {
          services.add({
            'id': doc.id,
            'serviceName': doc['service_name'],
            'providerUid': doc['provider_uid'],
            'requesterUid': doc['requester_uid'],
            'role': 'provider',
          });
        }
      }

      completedServices.assignAll(services);

      if (completedServices.isNotEmpty) {
        selectedServiceId.value = completedServices[0]['id'];
        role.value = completedServices[0]['role'];
      }
    } catch (e) {
      print("Error loading completed services: $e");
    }
  }

  Future<bool> hasReviewed(String serviceId, String userRole) async {
    try {
      var reviewSnapshot = await db
          .collection('reviews')
          .where('service_id', isEqualTo: serviceId)
          .where('from_uid', isEqualTo: currentUser!.uid)
          .get();

      return reviewSnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if user has reviewed: $e");
      return false;
    }
  }

  void updateSelectedService(String serviceId) {
    selectedServiceId.value = serviceId;
    Map<String, dynamic> selectedService = completedServices.firstWhere(
      (service) => service['id'] == serviceId,
    );
    role.value = selectedService['role'];
  }

  void updateReviewTextBoxColor(bool isFocused) {
    isReviewTextBoxFocused.value = isFocused;
  }

  void formatReviewText() {
    String text = reviewDescriptionController.text;
    text = text.trim();
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    reviewDescriptionController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void addReview(BuildContext context) async {
    if (reviewDescriptionController.text.trim().isEmpty ||
        rating.value == 0 ||
        selectedServiceId.value.isEmpty) {
      showRoundedErrorDialog(context, 'Please complete all fields.');
      return;
    }

    formatReviewText();

    Map<String, dynamic> selectedService = completedServices.firstWhere(
      (service) => service['id'] == selectedServiceId.value,
    );

    String toUid = selectedService['role'] == 'requester'
        ? selectedService['providerUid']
        : selectedService['requesterUid'];

    try {
      DocumentReference reviewRef = await db.collection('reviews').add({
        'from_uid': currentUser!.uid,
        'to_uid': toUid,
        'service_id': selectedServiceId.value,
        'service_type': role.value,
        'review_text': reviewDescriptionController.text,
        'rating': rating.value,
        'timestamp': Timestamp.now(),
      });

      await reviewRef.update({'review_id': reviewRef.id});

      Get.back(); // This will navigate back to the previous screen
    } catch (e) {
      showRoundedErrorDialog(context, 'Error adding review: $e');
    }
  }

  void showRoundedErrorDialog(BuildContext context, String message) {
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

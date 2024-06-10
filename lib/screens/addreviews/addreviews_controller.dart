import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReviewController extends GetxController {
  final selectedUserId = ''.obs;
  final role = 'requester'.obs;
  final rating = 0.obs;
  final reviewDescriptionController = TextEditingController();
  final userAccounts = <Map<String, dynamic>>[].obs;
  final services = <Map<String, dynamic>>[].obs;
  final selectedServiceId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserAccounts();
  }

  void loadUserAccounts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').limit(5).get();

    userAccounts.value = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['username'],
      };
    }).toList();

    if (userAccounts.isNotEmpty) {
      selectedUserId.value = userAccounts[0]['id'];
      loadServices(); // Load services for the first user by default
    }
  }

  void loadServices() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('services')
        .where(role.value == 'provider' ? 'provider_uid' : 'requester_uid',
            isEqualTo: selectedUserId.value)
        .get();

    services.value = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['service_name'],
      };
    }).toList();

    if (services.isNotEmpty) {
      selectedServiceId.value = services[0]['id'];
    }
  }

  void addReview(BuildContext context) async {
    if (reviewDescriptionController.text.isEmpty ||
        rating.value == 0 ||
        selectedServiceId.value.isEmpty) {
      showRoundedErrorDialog(context, 'Please complete all fields.');
      return;
    }

    await FirebaseFirestore.instance.collection('reviews').add({
      'from_uid':
          FirebaseAuth.instance.currentUser!.uid, // Use logged in user ID
      'to_uid': selectedUserId.value,
      'service_id': selectedServiceId.value,
      'service_type': role.value,
      'review_text': reviewDescriptionController.text,
      'rating': rating.value,
      'timestamp': Timestamp.now(),
    });

    Get.back();
  }

  void showRoundedErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

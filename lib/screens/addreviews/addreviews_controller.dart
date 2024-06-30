import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../../common/data/data.dart';
import '../../common/values/values.dart';

class AddReviewController extends GetxController {
  final selectedUserId = ''.obs;
  final role = 'all'.obs; // Default to 'all'
  final rating = 0.obs;
  final reviewDescriptionController = TextEditingController();
  final userAccounts = <Map<String, dynamic>>[].obs;
  final services = <Map<String, dynamic>>[].obs;
  final selectedServiceId = ''.obs;

  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadUserAccounts();
  }

  void loadUserAccounts() async {
    String currentUserId = currentUser!.uid;

    // Fetch services with "Completed" status
    QuerySnapshot completedServicesSnapshot = await db
        .collection('services')
        .where('status', isEqualTo: 'Completed')
        .get();

    // Extract unique user IDs from these services
    Set<String> userIds = {};
    for (var doc in completedServicesSnapshot.docs) {
      if (doc['provider_uid'] != currentUserId) {
        userIds.add(doc['provider_uid']);
      }
      if (doc['requester_uid'] != currentUserId) {
        userIds.add(doc['requester_uid']);
      }
    }

    if (userIds.isEmpty) {
      userAccounts.clear();
      return;
    }

    // Fetch user accounts based on these user IDs
    QuerySnapshot usersSnapshot = await db
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds.toList())
        .get();

    userAccounts.value = usersSnapshot.docs.map((doc) {
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
    if (selectedUserId.value.isEmpty) {
      services.clear();
      return;
    }

    Query completedServicesQuery =
        db.collection('services').where('status', isEqualTo: 'Completed');

    if (role.value != 'all') {
      if (role.value == 'requester') {
        completedServicesQuery = completedServicesQuery.where('requester_uid',
            isEqualTo: selectedUserId.value);
      } else if (role.value == 'provider') {
        completedServicesQuery = completedServicesQuery.where('provider_uid',
            isEqualTo: selectedUserId.value);
      }
    } else {
      completedServicesQuery = completedServicesQuery.where('requester_uid',
          isEqualTo:
              selectedUserId.value); // Default role to requester for 'all'
    }

    QuerySnapshot servicesSnapshot = await completedServicesQuery.get();
    services.value = servicesSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['service_name'],
      };
    }).toList();

    if (services.isNotEmpty) {
      selectedServiceId.value = services[0]['id'];
    } else {
      selectedServiceId.value = '';
    }
  }

  void addReview(BuildContext context) async {
    if (reviewDescriptionController.text.isEmpty ||
        rating.value == 0 ||
        selectedServiceId.value.isEmpty) {
      showRoundedErrorDialog(context, 'Please complete all fields.');
      return;
    }

    await db.collection('reviews').add({
      'from_uid': currentUser!.uid, // Use logged in user ID
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

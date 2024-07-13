import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../reviews_index.dart';

class DetailAddReviewController extends GetxController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final selectedRating = 0.obs;
  final reviewText = ''.obs;
  final hasAlreadyReviewed = false.obs;

  late final String serviceId;
  late final String toUid;
  late final String serviceType;

  @override
  void onInit() {
    super.onInit();
    serviceId = Get.parameters['doc_id'] ?? '';
    toUid = Get.parameters['to_uid'] ?? '';
    serviceType =
        Get.parameters['requested'] == 'true' ? 'provider' : 'requester';
    checkExistingReview();
  }

  Future<void> checkExistingReview() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    final querySnapshot = await db
        .collection('reviews')
        .where('from_uid', isEqualTo: currentUser.uid)
        .where('service_id', isEqualTo: serviceId)
        .get();

    hasAlreadyReviewed.value = querySnapshot.docs.isNotEmpty;
  }

  void setSelectedRating(int rating) {
    selectedRating.value = rating;
  }

  void setReviewText(String text) {
    reviewText.value = text;
  }

  Future<void> submitReview() async {
    if (hasAlreadyReviewed.value) {
      print('You have already reviewed this service');
      return;
    }

    if (selectedRating.value == 0 || reviewText.value.isEmpty) {
      print('Please provide both rating and review text');
      return;
    }

    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        print('current user is empty');
        return;
      }

      final newReview = {
        'from_uid': currentUser.uid,
        'to_uid': toUid,
        'rating': selectedRating.value,
        'review_text': reviewText.value,
        'service_id': serviceId,
        'service_type': serviceType,
        'timestamp': FieldValue.serverTimestamp(),
      };

      DocumentReference docRef = await db.collection('reviews').add(newReview);

      // Update the document with its own ID
      await docRef.update({'review_id': docRef.id});

      Get.back(); // Close the review modal
      // Refresh the reviews list
      Get.find<DetailReviewController>().fetchUserReviews();

      // Set hasAlreadyReviewed to true to prevent multiple submissions
      hasAlreadyReviewed.value = true;
    } catch (e) {
      print('Error submitting review: $e');
    }
  }
}

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/storage/storage.dart';
import '../reviews_index.dart';

class DetailAddReviewController extends GetxController {
  
  var doc_id;
  var serviceType;
  var requested_id;
  
  final userToken = UserStore.to.token;
  final db = FirebaseFirestore.instance;

  final selectedRating = 0.obs;
  final reviewText = ''.obs;
  final hasAlreadyReviewed = false.obs;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print('data: $data');
    doc_id = data['doc_id'] ?? '';
    requested_id = data['requester_id'] ?? '';
    serviceType = data['requested'] == 'true' ? 'provider' : 'requester';
    print('serviceId: $doc_id, toUid: $requested_id, serviceType: $serviceType');
    checkExistingReview();
    // print('serviceId: $serviceId, toUid: $toUid, serviceType: $serviceType');
  }

  Future<void> checkExistingReview() async {

    final querySnapshot = await db
        .collection('reviews')
        .where('from_uid', isEqualTo: userToken)
        .where('service_id', isEqualTo: doc_id)
        .get();

    print('Query snapshot: ${querySnapshot.docs}');

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
      
      final newReview = {
        'from_uid': userToken,
        'to_uid': requested_id,
        'rating': selectedRating.value,
        'review': reviewText.value.trim(),
        'service_id': doc_id,
        'service_type': serviceType,
        'timestamp': FieldValue.serverTimestamp(),
      };

      print(newReview);

      await db.collection('reviews').add(newReview);

      // Calculate new average rating for the user
      final userReviewsSnapshot = await db
          .collection('reviews')
          .where('to_uid', isEqualTo: requested_id)
          .get();

      double totalRating = 0;
      int totalReviews = userReviewsSnapshot.docs.length;

      // Calculate total rating
      for (var doc in userReviewsSnapshot.docs) {
        totalRating += doc.data()['rating'];
      }

      // Calculate new average rating
      double newRating = totalRating / totalReviews;

      // Update user's rating in 'users' collection
      await db.collection('users').doc(requested_id).update({
        'rating': newRating,
      });

      Get.back(); // Close the review modal
      // Refresh the reviews list
      Get.find<DetailReviewController>().fetchUserReviews();
      update();

      // Set hasAlreadyReviewed to true to prevent multiple submissions
      hasAlreadyReviewed.value = true;
    } catch (e) {
      print('Error submitting review: $e');
    }
  }
}

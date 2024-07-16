import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/storage/storage.dart';
import '../reviews_index.dart';

class DetailAddReviewController extends GetxController {
  
  final userToken = UserStore.to.token;
  final db = FirebaseFirestore.instance;

  final selectedRating = 0.obs;
  final reviewText = ''.obs;
  final hasAlreadyReviewed = false.obs;

  late final String serviceId;
  late final String toUid;
  late final String serviceType;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print('data: $data');
    serviceId = data['doc_id'] ?? '';
    toUid = data['requester_id'] ?? '';
    serviceType = data['requested'] == 'true' ? 'provider' : 'requester';
    print('serviceId: $serviceId, toUid: $toUid, serviceType: $serviceType');
    checkExistingReview();
    // print('serviceId: $serviceId, toUid: $toUid, serviceType: $serviceType');
  }

  Future<void> checkExistingReview() async {

    final querySnapshot = await db
        .collection('reviews')
        .where('from_uid', isEqualTo: userToken)
        .where('service_id', isEqualTo: serviceId)
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
        'to_uid': toUid,
        'rating': selectedRating.value,
        'review': reviewText.value.trim(),
        'service_id': serviceId,
        'service_type': serviceType,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await db.collection('reviews').add(newReview);

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

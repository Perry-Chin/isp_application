import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../common/data/data.dart';

class DetailReviewController extends GetxController {
  final String serviceId = Get.parameters['service_id'] ?? '';
  final db = FirebaseFirestore.instance;

  final reviews = <Review>[].obs;
  final isLoading = true.obs;
  final averageRating = 0.0.obs;
  final totalReviews = 0.obs;
  final ratingCounts = <int, int>{}.obs;
  final sortType = 'Newest'.obs;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      isLoading(true);
      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('reviews')
          .where('service_id', isEqualTo: serviceId)
          .get();

      reviews.value = await Future.wait(
        snapshot.docs.map((doc) => _processReview(doc)),
      );

      _calculateStats();
      _sortReviews();
      isLoading(false);
      refreshController.refreshCompleted();
    } catch (e) {
      print('Error fetching reviews: $e');
      isLoading(false);
      refreshController.refreshFailed();
    }
  }

  Future<Review> _processReview(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    Review review = Review.fromFirestore(doc);
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await db.collection('users').doc(review.fromUid).get();
    if (userDoc.exists) {
      review.username = userDoc.data()?['username'];
      review.photoUrl = userDoc.data()?['photourl'];
    }
    return review;
  }

  void _calculateStats() {
    if (reviews.isEmpty) return;

    totalReviews.value = reviews.length;
    double sum = reviews.fold(0, (prev, review) => prev + review.rating);
    averageRating.value = sum / totalReviews.value;

    ratingCounts.clear();
    for (var review in reviews) {
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
    }
  }

  void _sortReviews() {
    switch (sortType.value) {
      case 'Newest':
        reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'Oldest':
        reviews.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'Highest Rating':
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rating':
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
  }

  void updateSortType(String newSortType) {
    sortType.value = newSortType;
    _sortReviews();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}

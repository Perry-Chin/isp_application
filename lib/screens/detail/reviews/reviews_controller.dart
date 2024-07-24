// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/data/data.dart';
import '../../../common/middlewares/middlewares.dart';
import '../../../common/storage/storage.dart';
import 'add_reviews/add_reviews_index.dart';

class DetailReviewController extends GetxController {

  var doc_id;
  var serviceType;
  var requested_id;
  var data_uid;
  var status;
  
  final db = FirebaseFirestore.instance;
  final reviews = <ReviewData>[].obs;
  final isLoading = true.obs;
  final hasAlreadyReviewed = false.obs;
  final averageRating = 0.0.obs;
  final totalReviews = 0.obs;
  final ratingCounts = <int, int>{}.obs;
  final sortType = 'Newest'.obs;
  final userToken = UserStore.to.token;
  final reviewList = <QueryDocumentSnapshot<ReviewData>>[].obs;
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  void onRefresh() => refreshData(refreshController, fetchUserReviews);
  void onLoading() => loadData(refreshController, fetchUserReviews);

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'];
    serviceType = data['requested'] == 'true' ? 'provider' : 'requester';
    requested_id = data['requester_id'];
    data_uid = data['data_uid'];
    status = data['status'];
    checkExistingReview();
    fetchUserReviews();
  }

  Stream<List<QueryDocumentSnapshot<ReviewData>>> getReviewStream() {
    return db
      .collection('reviews')
      .where(data_uid, isEqualTo: requested_id)
      .where('service_type', isEqualTo: serviceType)
      .withConverter<ReviewData>(
        fromFirestore: ReviewData.fromFirestore,
        toFirestore: (ReviewData reviewData, _) => reviewData.toFirestore(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  Stream<List<DocumentSnapshot<UserData>>> getUserStream(List<String> userIds) {
    return db
      .collection('users')
      .where(FieldPath.documentId, whereIn: userIds)
      .withConverter<UserData>(
        fromFirestore: UserData.fromFirestore,
        toFirestore: (UserData userData, _) => userData.toFirestore(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  // Combine the streams to get user data for each payment
  Stream<Map<String, UserData?>> getCombinedStream() {
    return getReviewStream().switchMap((reviewDocs) {
      List<String> userIds = reviewDocs.expand((doc) {
        return [doc.data().fromUid, doc.data().toUid];
      }).whereType<String>().toSet().toList();
      if (userIds.isEmpty) {
        return Stream.value({});
      }
      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(userDocs.map((doc) {
          return MapEntry(doc.id, doc.data());
        }));
        return userDataMap;
      });
    });
  }

  Stream<Map<String, UserData?>> get combinedStream => getCombinedStream();

  Future<void> fetchUserReviews() async {
    var reviews = await db
      .collection('reviews')
      .where('to_uid', isEqualTo: requested_id)
      .where('service_type', isEqualTo: serviceType)
      .withConverter<ReviewData>(
        fromFirestore: ReviewData.fromFirestore,
        toFirestore: (ReviewData reviewData, _) => reviewData.toFirestore(),
      ).get();
    
    reviewList.assignAll(reviews.docs);
    print('reviewList: ${reviewList.length}');
    _calculateStats();
    update(); 
  }

  Future<void> checkExistingReview() async {
    
    final querySnapshot = await db
        .collection('reviews')
        .where('from_uid', isEqualTo: userToken)
        .where('service_id', isEqualTo: doc_id)
        .get();

    hasAlreadyReviewed.value = querySnapshot.docs.isNotEmpty;
  }

  void _calculateStats() {
    // Calculate total number of reviews
    totalReviews.value = reviewList.length;

    // Calculate average rating
    double totalRating = 0;
    ratingCounts.clear();

    // Iterate through reviews to calculate total rating and count for each rating
    for (var reviewSnapshot in reviewList) {
      var review = reviewSnapshot.data(); // Assuming ReviewData is obtained from reviewSnapshot
      totalRating += review.rating;

      // Count occurrences of each rating
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
    }

    // Calculate average rating if there are reviews
    averageRating.value = totalReviews.value > 0 ? totalRating / totalReviews.value : 0.0;
  
    update();
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

  // Helper functions for add review
  void addReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const DetailAddReviewPage(),
      )
    );
  }
}

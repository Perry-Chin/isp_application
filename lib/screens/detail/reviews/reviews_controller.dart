import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/data/data.dart';
import 'add_reviews/add_reviews_index.dart';

class DetailReviewController extends GetxController {
  final String docId = Get.parameters['doc_id'] ?? '';
  final String requested = Get.parameters['requested'] ?? 'false';
  final db = FirebaseFirestore.instance;
  final reviews = <Review>[].obs;
  final isLoading = true.obs;
  final averageRating = 0.0.obs;
  final totalReviews = 0.obs;
  final ratingCounts = <int, int>{}.obs;
  final sortType = 'Newest'.obs;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  late Stream<Map<String, UserData?>> combinedStream;

  @override
  void onInit() {
    super.onInit();
    if (docId.isNotEmpty) {
      combinedStream = getCombinedStream();
      fetchUserReviews();
    } else {
      print('Error: Document ID is empty');
      isLoading(false);
    }
  }

  Stream<Map<String, UserData?>> getCombinedStream() {
    return db
        .collection('service')
        .doc(docId)
        .snapshots()
        .switchMap((serviceDoc) {
      var serviceData = ServiceData.fromFirestore(serviceDoc, null);
      var userIds = [
        if (serviceData.reqUserid != null) serviceData.reqUserid!,
        if (serviceData.provUserid != null) serviceData.provUserid!,
      ];

      print('Combined Stream User IDs: $userIds');

      return db
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .snapshots()
          .map((userSnapshot) {
        return Map.fromEntries(userSnapshot.docs
            .map((doc) => MapEntry(doc.id, UserData.fromFirestore(doc, null))));
      });
    });
  }

  Future<void> fetchUserReviews() async {
    try {
      isLoading(true);
      await combinedStream.first.then((userDataMap) async {
        var serviceDoc = await db.collection('service').doc(docId).get();
        var serviceData = serviceDoc.data();

        if (serviceData == null) {
          print('Error: Service data is null');
          return;
        }

        // print('Service Data: $serviceData');

        // Determine which user's reviews to fetch based on 'requested' parameter
        String? userId;
        if (requested == 'true') {
          // Current user is the requester, so fetch provider's reviews
          userId = serviceData['provider_uid'] as String?;
        } else {
          // Current user is the provider or potential provider, so fetch requester's reviews
          userId = serviceData['requester_uid'] as String?;
        }

        if (userId == null) {
          print('Error: User ID is null');
          return;
        }
        // print('Requested parameter: $requested');
        // print(
        //     'Fetching reviews for role: ${requested == 'true' ? 'Provider' : 'Requester'}');
        // print('User ID to fetch reviews for: $userId');

        // print('Fetching reviews for User ID: $userId');

        QuerySnapshot<Map<String, dynamic>> snapshot = await db
            .collection('reviews')
            .where('to_uid', isEqualTo: userId)
            .get();

        reviews.value = await Future.wait(
          snapshot.docs.map((doc) => _processReview(doc, userDataMap)),
        );

        _calculateStats();
        _sortReviews();
      });
    } catch (e) {
      print('Error fetching user reviews: $e');
    } finally {
      isLoading(false);
      refreshController.refreshCompleted();
    }
  }

  Future<Review> _processReview(DocumentSnapshot<Map<String, dynamic>> doc,
      Map<String, UserData?> userDataMap) async {
    Review review = Review.fromFirestore(doc);
    String reviewerUserId = review.fromUid;

    print('Processing review from Reviewer User ID: $reviewerUserId');

    if (userDataMap.containsKey(reviewerUserId)) {
      UserData? userData = userDataMap[reviewerUserId];
      review.username = userData?.username;
      review.photoUrl = userData?.photourl;
    }

    return review;
  }

  void _calculateStats() {
    totalReviews.value = reviews.length;
    ratingCounts.clear();
    double totalRating = 0;
    for (var review in reviews) {
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
      totalRating += review.rating;
    }
    averageRating.value =
        totalReviews.value > 0 ? totalRating / totalReviews.value : 0.0;
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

  void onRefresh() => _refreshData(refreshController, fetchUserReviews);
  void onLoading() => _loadData(refreshController, fetchUserReviews);

  // Helper functions for refresh and load
  void _refreshData(
      RefreshController controller, Future<void> Function() loadData) {
    loadData().then((_) {
      controller.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      controller.refreshFailed();
    });
  }

  void _loadData(
      RefreshController controller, Future<void> Function() loadData) {
    loadData().then((_) {
      controller.loadComplete();
    }).catchError((_) {
      controller.loadFailed();
    });
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

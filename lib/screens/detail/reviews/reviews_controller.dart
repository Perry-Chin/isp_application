// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/data/data.dart';
import '../../../common/storage/storage.dart';
import 'add_reviews/add_reviews_index.dart';

class DetailReviewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Variables
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
  final selectedTab = 'All'.obs;

  final Map<String, RefreshController> refreshControllers = {
    'All': RefreshController(initialRefresh: false),
    'Provider': RefreshController(initialRefresh: false),
    'Requester': RefreshController(initialRefresh: false),
  };

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    var data = Get.parameters;
    doc_id = data['doc_id'];
    serviceType = data['requested'] == 'true' ? 'provider' : 'requester';
    requested_id = data['requester_id'];
    data_uid = data['data_uid'];
    status = data['status'];
    checkExistingReview();
    fetchUserReviews().then((_) {
      filterReviewsByTab(); // This will now set the initial "All" reviews
    });

    // Listen to tab changes
    tabController.addListener(() {
      updateSelectedTab(['All', 'Provider', 'Requester'][tabController.index]);
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }

  void onRefresh(String tabType) {
    fetchUserReviews().then((_) {
      refreshControllers[tabType]?.refreshCompleted();
      update();
    });
  }

  void onLoading(String tabType) {
    fetchUserReviews().then((_) {
      refreshControllers[tabType]?.loadComplete();
      update();
    });
  }

  Stream<List<QueryDocumentSnapshot<ReviewData>>> getReviewStream() {
    return db
        .collection('reviews')
        .where(data_uid, isEqualTo: requested_id)
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

  Stream<Map<String, UserData?>> getCombinedStream() {
    return getReviewStream().switchMap((reviewDocs) {
      print(reviewDocs);
      List<String> userIds = reviewDocs.expand((doc) => [doc.data().fromUid, doc.data().toUid])
        .whereType<String>()
        .toSet()
        .toList();
        
      if (userIds.isEmpty) {
        print('Error: User ID is null or empty');
        return Stream.value({});
      }
      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(
            userDocs.map((doc) => MapEntry(doc.id, doc.data())));
        return userDataMap;
      });
    });
  }

  Stream<Map<String, UserData?>> get combinedStream => getCombinedStream();

  Future<void> fetchUserReviews() async {
    var reviewsQuery = await db
        .collection('reviews')
        .where('to_uid', isEqualTo: requested_id)
        .withConverter<ReviewData>(
          fromFirestore: ReviewData.fromFirestore,
          toFirestore: (ReviewData reviewData, _) => reviewData.toFirestore(),
        )
        .get();

    reviewList.assignAll(reviewsQuery.docs);
    reviews.assignAll(reviewList.map((doc) => doc.data()).toList());
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
    totalReviews.value = reviewList.length;
    double totalRating = 0;
    ratingCounts.clear();

    for (var reviewSnapshot in reviewList) {
      var review = reviewSnapshot.data();
      totalRating += review.rating;
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
    }

    averageRating.value =
        totalReviews.value > 0 ? totalRating / totalReviews.value : 0.0;

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

  void updateSelectedTab(String tab) {
    selectedTab.value = tab;
    int index = ['All', 'Provider', 'Requester'].indexOf(tab);
    if (index != -1) {
      tabController.animateTo(index);
    }
  }

  void filterReviewsByTab() {
    switch (selectedTab.value) {
      case 'All':
        reviews.assignAll(reviewList.map((doc) => doc.data()).toList());
        break;
      case 'Provider':
        reviews.assignAll(reviewList
            .map((doc) => doc.data())
            .where((review) => review.serviceType.toLowerCase() == 'provider')
            .toList());
        break;
      case 'Requester':
        reviews.assignAll(reviewList
            .map((doc) => doc.data())
            .where((review) => review.serviceType.toLowerCase() == 'requester')
            .toList());
        break;
    }
    _sortReviews();
    update();
  }

  List<ReviewData> getFilteredReviews(String type) {
    switch (type) {
      case 'All':
        return reviews;
      case 'Provider':
        return reviews
            .where((review) => review.serviceType.toLowerCase() == 'provider')
            .toList();
      case 'Requester':
        return reviews
            .where((review) => review.serviceType.toLowerCase() == 'requester')
            .toList();
      default:
        return reviews;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  void addReview(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const DetailAddReviewPage(),
            ));
  }
}

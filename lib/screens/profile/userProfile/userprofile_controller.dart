import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/data/data.dart';

class UserProfileController extends GetxController {
  final db = FirebaseFirestore.instance;
  final user = Rx<UserData?>(null);
  final allReviews = <ReviewData>[].obs;
  final filteredReviews = <ReviewData>[].obs;
  final Rx<String> currentTab = 'All'.obs;
  final Rx<String> currentSortType = 'Newest'.obs;

  late String userId;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments['userId'];
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        user.value = UserData.fromFirestore(userDoc, null);
        await fetchUserReviews();
        await updateAverageRating();
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchUserReviews() async {
    try {
      QuerySnapshot<Map<String, dynamic>> reviewsSnapshot = await db
          .collection('reviews')
          .where('to_uid', isEqualTo: userId)
          .get();

      final fetchedReviews = await Future.wait(
          reviewsSnapshot.docs.map((doc) => _processReview(doc)));

      allReviews.assignAll(fetchedReviews);
      filterReviews(currentTab.value);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<ReviewData> _processReview(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    ReviewData review = ReviewData.fromFirestore(doc, null);

    if (review.fromUid.isEmpty) {
      print('Error: User ID who gave the review is empty');
      return review;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(review.fromUid).get();
      if (userDoc.exists) {
        // review.username = userDoc.data()?['username'];
        // review.photoUrl = userDoc.data()?['photourl'];
      }
    } catch (e) {
      print('Error fetching user data for review: $e');
    }

    return review;
  }

  void filterReviews(String type) {
    currentTab.value = type;
    switch (type) {
      case 'All':
        filteredReviews.assignAll(allReviews);
        break;
      case 'Provider':
        filteredReviews.assignAll(allReviews
            .where((review) => review.serviceType.toLowerCase() == 'provider'));
        break;
      case 'Requester':
        filteredReviews.assignAll(allReviews.where(
            (review) => review.serviceType.toLowerCase() == 'requester'));
        break;
    }
    sortReviews(currentSortType.value);
  }

  void sortReviews(String sortType) {
    currentSortType.value = sortType;
    switch (sortType) {
      case 'Newest':
        filteredReviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'Oldest':
        filteredReviews.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'Highest Rating':
        filteredReviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rating':
        filteredReviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
  }

  Future<void> updateAverageRating() async {
    try {
      if (allReviews.isEmpty) return;

      double sum = allReviews.fold(0, (prev, review) => prev + review.rating);
      double averageRating = sum / allReviews.length;

      await db
          .collection('users')
          .doc(userId)
          .update({'rating': averageRating});

      user.update((val) {
        if (val != null) {
          val.rating = averageRating;
        }
      });
    } catch (e) {
      print('Error updating average rating: $e');
    }
  }
}

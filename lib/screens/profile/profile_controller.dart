import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../common/data/data.dart';
import '../../common/storage/storage.dart';

class ProfileController extends GetxController {
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final user = Rx<UserData?>(null);
  final allReviews = <Review>[].obs;
  final filteredReviews = <Review>[].obs;
  final Rx<String> currentTab = 'All'.obs;
  final Rx<String> currentSortType = 'Newest'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    if (token.isEmpty) {
      print('Error: User token is null or empty');
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(token).get();

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
    if (token.isEmpty) {
      print('Error: User token is null or empty');
      return;
    }

    try {
      QuerySnapshot<Map<String, dynamic>> reviewsSnapshot = await db
          .collection('reviews')
          .where('to_uid', isEqualTo: token)
          .get();

      final fetchedReviews = await Future.wait(
          reviewsSnapshot.docs.map((doc) => _processReview(doc)));

      allReviews.assignAll(fetchedReviews);
      filterReviews(currentTab.value);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<Review> _processReview(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    Review review = Review.fromFirestore(doc);

    if (review.fromUid.isEmpty) {
      print('Error: User ID who gave the review is empty');
      return review;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(review.fromUid).get();
      if (userDoc.exists) {
        review.username = userDoc.data()?['username'];
        review.photoUrl = userDoc.data()?['photourl'];
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
    if (token.isEmpty) {
      print('Error: User token is null or empty');
      return;
    }

    try {
      if (allReviews.isEmpty) return;

      double sum = allReviews.fold(0, (prev, review) => prev + review.rating);
      double averageRating = sum / allReviews.length;

      await db.collection('users').doc(token).update({'rating': averageRating});

      user.update((val) {
        if (val != null) {
          val.rating = averageRating;
        }
      });
    } catch (e) {
      print('Error updating average rating: $e');
    }
  }

  void updateUserProfile(UserData updatedUser) {
    user.value = updatedUser;
  }
}

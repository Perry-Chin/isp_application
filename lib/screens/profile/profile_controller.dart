import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../common/data/data.dart';
import '../../common/storage/storage.dart';

class ProfileController extends GetxController {
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final user = Rx<UserData?>(null);
  final reviews = <Review>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(token).get();

      if (userDoc.exists) {
        user.value = UserData.fromFirestore(userDoc, null);
        await fetchReviews('All');
        await updateAverageRating();
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchReviews(String type) async {
    try {
      Query<Map<String, dynamic>> receivedQuery =
          db.collection('reviews').where('to_uid', isEqualTo: token);
      Query<Map<String, dynamic>> givenQuery =
          db.collection('reviews').where('from_uid', isEqualTo: token);

      if (type == 'Provider' || type == 'Requester') {
        receivedQuery =
            receivedQuery.where('service_type', isEqualTo: type.toLowerCase());
        givenQuery =
            givenQuery.where('service_type', isEqualTo: type.toLowerCase());
      }

      QuerySnapshot<Map<String, dynamic>> receivedSnapshot =
          await receivedQuery.get();
      QuerySnapshot<Map<String, dynamic>> givenSnapshot =
          await givenQuery.get();

      final fetchedReviews = await Future.wait([
        ...receivedSnapshot.docs
            .map((doc) => _processReview(doc, isReceived: true)),
        ...givenSnapshot.docs
            .map((doc) => _processReview(doc, isReceived: false))
      ]);

      reviews.assignAll(fetchedReviews);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<Review> _processReview(DocumentSnapshot<Map<String, dynamic>> doc,
      {required bool isReceived}) async {
    Review review = Review.fromFirestore(doc);
    String userIdToFetch = isReceived ? review.fromUid : review.toUid;
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await db.collection('users').doc(userIdToFetch).get();
    if (userDoc.exists) {
      review.username = userDoc.data()?['username'];
      review.photoUrl = userDoc.data()?['photourl'];
    }
    review.isReceived = isReceived;
    return review;
  }

  Future<void> updateAverageRating() async {
    try {
      if (reviews.isEmpty) return;

      double sum = reviews.fold(0, (prev, review) => prev + review.rating);
      double averageRating = sum / reviews.length;

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

  Future<void> addReview(Review newReview) async {
    try {
      await db.collection('reviews').add(newReview.toFirestore());
      await fetchReviews('All');
      await updateAverageRating();
    } catch (e) {
      print('Error adding review: $e');
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await db.collection('reviews').doc(reviewId).delete();
      await fetchReviews('All');
      await updateAverageRating();
    } catch (e) {
      print('Error deleting review: $e');
    }
  }

  void updateUserProfile(UserData updatedUser) {
    user.value = updatedUser;
  }
}

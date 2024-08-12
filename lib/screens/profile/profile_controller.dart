import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import '../../common/middlewares/middlewares.dart';

class ProfileController extends GetxController {
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final user = Rxn<UserData>();
  final rating = 0.0.obs;
  final allReviews = <ReviewData>[].obs;
  final filteredReviews = <ReviewData>[].obs;
  final Rx<String> currentTab = 'All'.obs;
  final Rx<String> currentSortType = 'Newest'.obs;
  final usernames = <String, String>{}.obs;
  final photoUrls = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData([String? userId]) async {
    try {
      final doc = await db.collection('users').doc(token).get();

      if (doc.exists) {
        final data = doc.data()!;
        user.value = UserData(
          id: doc.id,
          username: data['username'],
          email: data['email'],
          photourl: data['photourl'],
        );
        if (data['rating'] != null) {
          rating.value = data['rating'];
          await fetchUserReviews();
          await updateAverageRating();
        } else {
          rating.value = 0.0;
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Stream<List<QueryDocumentSnapshot<ReviewData>>> getReviewStream(
      [String? userId]) {
    final String fetchUserId = userId ?? token;

    return db
        .collection('reviews')
        .where('to_uid', isEqualTo: fetchUserId)
        .orderBy('timestamp', descending: true)
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

  Stream<Map<String, UserData?>> getCombinedStream([String? userId]) {
    return RouteFirestoreMiddleware.getCombinedStream<ReviewData, UserData>(
      primaryStream: () => getReviewStream(userId),
      secondaryStream: (userIds) => getUserStream(userIds),
      getSecondaryId: (review) => review.fromUid,
    );
  }

  Stream<Map<String, UserData?>> get combinedStream => getCombinedStream();

  Future<void> fetchUserReviews([String? userId]) async {
    final String fetchUserId = userId ?? token;

    if (fetchUserId.isEmpty) {
      print('Error: User ID is null or empty');
      return;
    }

    try {
      QuerySnapshot<Map<String, dynamic>> reviewsSnapshot = await db
          .collection('reviews')
          .where('to_uid', isEqualTo: fetchUserId)
          // .orderBy('timestamp', descending: true)
          .get();

      final fetchedReviews = reviewsSnapshot.docs
          .map((doc) => ReviewData.fromFirestore(doc, null))
          .toList();

      allReviews.assignAll(fetchedReviews);
      filterReviews(currentTab.value);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
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

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  Future<void> updateAverageRating() async {
    if (token.isEmpty) {
      print('Error: User token is null or empty');
      return;
    }

    try {
      double averageRating = 0;

      if (allReviews.isNotEmpty) {
        double sum = allReviews.fold(0, (prev, review) => prev + review.rating);
        averageRating = sum / allReviews.length;
      }

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

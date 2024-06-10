import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';

class ProfileController extends GetxController {
  ProfileController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final user = Rx<UserData?>(null);
  final reviews = <Review>[].obs; // Observable list of reviews

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      DocumentSnapshot<UserData> userDoc = await db
          .collection('users')
          .doc(token)
          .withConverter<UserData>(
            fromFirestore: (snapshot, _) =>
                UserData.fromFirestore(snapshot, null),
            toFirestore: (UserData userData, _) => userData.toFirestore(),
          )
          .get();

      if (userDoc.exists) {
        user.value = userDoc.data();
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Method to fetch reviews from Firestore
  Future<void> fetchReviews(String type) async {
    try {
      Query<Map<String, dynamic>> query =
          db.collection('reviews').where('to_uid', isEqualTo: user.value?.id);

      if (type == 'Provider' || type == 'Requester') {
        query = query.where('service_type', isEqualTo: type.toLowerCase());
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

      final fetchedReviews =
          querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();

      for (var review in fetchedReviews) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await db.collection('users').doc(review.fromUid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          review.fromUsername = userData?['username'];
          review.fromPhotoUrl = userData?['photourl'];
        }
      }

      reviews.value = fetchedReviews;
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  void updateUserProfile(UserData updatedUser) {
    user.value = updatedUser;
  }
}

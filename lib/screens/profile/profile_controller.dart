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
  void fetchReviews(String type) async {
    try {
      Query<Map<String, dynamic>> query = db.collection('reviews');
      if (type != 'All') {
        query = query.where('service_type', isEqualTo: type.toLowerCase());
      }
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      reviews.value =
          querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  void updateUserProfile(UserData updatedUser) {
    user.value = updatedUser;
  }
}

// Model class for Review
class Review {
  final String id;
  final String user;
  final String date;
  final String review;
  final int rating;

  Review({
    required this.id,
    required this.user,
    required this.date,
    required this.review,
    required this.rating,
  });

  factory Review.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Review(
      id: doc.id,
      user: data['user'],
      date: data['date'],
      review: data['review'],
      rating: data['rating'],
    );
  }
}

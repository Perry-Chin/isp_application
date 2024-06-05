// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';

class ProfileController extends GetxController {
  ProfileController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final user = Rx<UserData?>(null);

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

  void updateUserProfile(UserData updatedUser) {
    user.value = updatedUser;
  }
}

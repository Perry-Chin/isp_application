import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../common/data/data.dart';
import '../../../../common/storage/storage.dart';

class PaymentController extends GetxController {
  // Variables
  final user = Rx<UserData?>(null);
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetch user data by token
  void fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await db.collection('users').doc(token).get();

      if (userDoc.exists) {
        print(userDoc.data());
        user.value = UserData.fromFirestore(userDoc, null);
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
// settings Controller

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../common/routes/routes.dart';
import '../../common/storage/storage.dart';

class SettingsxController extends GetxController {
  SettingsxController();

  Future<void> onLogOut() async {
    await UserStore.to.onLogout();
    await FirebaseAuth.instance.signOut();
    Get.offAndToNamed(AppRoutes.login);
  }
  
}

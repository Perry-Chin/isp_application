import 'package:get/get.dart';

import '../../common/routes/routes.dart';
import '../../common/storage/storage.dart';
import 'state.dart';

class WelcomeController extends GetxController {
  final state = WelcomeState();
  WelcomeController();
  
  //Change the page index when user move
  changePage(int index) async {
    state.index.value = index;
  }

  //Handle login
  handleLogin() async {
    await ConfigStore.to.saveAlreadyOpen();
    Get.offAndToNamed(AppRoutes.login);
  }
}
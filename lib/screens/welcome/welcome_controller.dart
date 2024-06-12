import 'package:get/get.dart';

import '../../common/routes/names.dart';
import '../../common/routes/routes.dart';
import '../../common/storage/storage.dart';
import 'welcome_state.dart';

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
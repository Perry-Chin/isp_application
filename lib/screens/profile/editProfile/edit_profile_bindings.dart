import 'package:get/get.dart';
import 'edit_profile_controller.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}

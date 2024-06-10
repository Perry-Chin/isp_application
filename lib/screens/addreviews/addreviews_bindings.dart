import 'package:get/get.dart';
import 'addreviews_controller.dart';

class AddReviewsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddReviewController>(() => AddReviewController());
  }
}

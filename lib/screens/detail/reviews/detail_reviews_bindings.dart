import 'package:get/get.dart';
import 'detail_reviews_controller.dart';

class DetailReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailReviewController>(() => DetailReviewController());
  }
}

import 'package:get/get.dart';

import 'add_reviews_index.dart';

class DetailAddReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAddReviewController>(() => DetailAddReviewController());
  }
}
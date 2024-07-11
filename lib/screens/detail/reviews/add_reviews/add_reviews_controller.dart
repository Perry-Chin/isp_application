import 'package:get/get.dart';

class DetailAddReviewController extends GetxController {
  var selectedRating = 0.obs;

  void setSelectedRating(int rating) {
    selectedRating.value = rating;
  }
}
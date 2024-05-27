import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'navbar_index.dart';

class NavbarController extends GetxController {
  var state = NavbarState();
  late PageController pageController;

  void handlePageChanged(int index) {
    state.page = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: state.page);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

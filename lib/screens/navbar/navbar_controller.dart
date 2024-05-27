import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navbar_index.dart';

class NavbarController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';

class NavbarController extends GetxController {
  final state = NavbarState();
  NavbarController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handlePageChanged(int index) {
    state.page = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    tabTitles = ['Home', 'Schedule', 'Request', 'Message', 'Profile'];
    bottomTabs = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.message,
          color: Colors.red,
        ),
        activeIcon: Icon(
          Icons.message,
          color: Colors.blue,
        ),
        label: 'Home',
        backgroundColor: Colors.red
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.message,
          color: Colors.red,
        ),
        activeIcon: Icon(
          Icons.message,
          color: Colors.blue,
        ),
        label: 'Schedule',
        backgroundColor: Colors.red
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.message,
          color: Colors.red,
        ),
        activeIcon: Icon(
          Icons.message,
          color: Colors.blue,
        ),
        label: 'Request',
        backgroundColor: Colors.red
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.contact_page,
          color: Colors.red,
        ),
        activeIcon: Icon(
          Icons.contact_page,
          color: Colors.blue,
        ),
        label: 'Message',
        backgroundColor: Colors.red
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
          color: Colors.red,
        ),
        activeIcon: Icon(
          Icons.person,
          color: Colors.blue,
        ),
        label: 'Profile',
        backgroundColor: Colors.red
      )
    ];
    pageController = PageController(initialPage: state.page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
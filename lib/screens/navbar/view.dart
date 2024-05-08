//Navbar View

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/storage/storage.dart';
import 'index.dart';

class NavbarPage extends GetView<NavbarController> {
  NavbarPage({super.key});
  final token = UserStore.to.token;

  @override
  Widget build(BuildContext context) {
    Widget buildPageView() {
      return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handlePageChanged,
        children: const [
          Center(child: Text("Home Page")),
          Center(child: Text("Schedule Page")),
          Center(child: Text("Request Page")),
          Center(child: Text("Message Page")),
          Center(child: Text("Profile Page")),
        ],
      );
    }

    Widget buildBottomNavigationBar() {
      return Obx(
        () => BottomNavigationBar(
          items: controller.bottomTabs,
          currentIndex: controller.state.page,
          type: BottomNavigationBarType.fixed,
          onTap: controller.handleNavBarTap,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedItemColor: Colors.red,
          selectedItemColor: Colors.blue,
        )
      );
    }

    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
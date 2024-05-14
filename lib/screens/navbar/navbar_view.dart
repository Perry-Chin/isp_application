//Navbar View
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/storage/storage.dart';
import '../home/home_index.dart';
import '../profile/profile_index.dart';
import '../request/request_index.dart';
import 'navbar_index.dart';

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
          HomePage(),
          Center(child: Text("Schedule Page")),
          Center(child: Text("Message Page")),
          ProfilePage(),
        ],
      );
    }

    Widget buildBottomNavigationBar() { 
      return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Obx(() => Icon(
                Icons.home,
                color: controller.state.page == 0 ? Colors.amber : Colors.black45,
              )),
              onPressed: () => controller.handleNavBarTap(0),
            ),
            IconButton(
              icon: Obx(() => Icon(
                Icons.calendar_month,
                color: controller.state.page == 1 ? Colors.amber : Colors.black45,
              )),
              onPressed: () => controller.handleNavBarTap(1),
            ),
            const SizedBox(width: 48.0), // Space for FAB
            IconButton(
              icon: Obx(() => Icon(
                Icons.message,
                color: controller.state.page == 2 ? Colors.amber : Colors.black45,
              )),
              onPressed: () => controller.handleNavBarTap(2),
            ),
            IconButton(
              icon: Obx(() => Icon(
                Icons.person,
                color: controller.state.page == 3 ? Colors.amber : Colors.black45,
              )),
              onPressed: () => controller.handleNavBarTap(3),
            ),
          ],
        ),
      );
    } 

    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildPageView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Navigate to the login screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RequestPage(),
          ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
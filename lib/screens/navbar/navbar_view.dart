//Navbar View
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_application/screens/home/home_index.dart';
import 'package:isp_application/screens/message/message_index.dart';
import 'package:isp_application/screens/profile/profile_index.dart';
import 'package:isp_application/screens/schedule/schedule_index.dart';

import '../../common/values/values.dart';
import 'navbar_index.dart';

class NavbarPage extends GetView<NavbarController> {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<NavbarController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                HomePage(),
                SchedulePage(),
                MessagePage(),
                ProfilePage()
              ],
            )
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.black45,
            selectedItemColor: AppColor.secondaryColor,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              _bottomNavigationBarItem(Icons.home, 'Home'),
              _bottomNavigationBarItem(Icons.calendar_month, 'Schedule'),
              _bottomNavigationBarItem(Icons.message, 'Message'),
              _bottomNavigationBarItem(Icons.person, 'Profile')
            ],
          ),
        );
      }
    );
  }

  _bottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label
    );
  }
}
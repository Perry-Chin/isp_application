// settings View

// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import 'settingsx_controller.dart';
import '../settings/contact/settings_contact_page.dart';

class SettingsxPage extends GetView<SettingsxController> {
  SettingsxPage({super.key});

  final SettingsxController _settingsxController = Get.put(SettingsxController());

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Settings"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColor.backgroundColor,
      body: ListView(
        children: [
          SizedBox(
            height: 75,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactPage(),
                  ),//1
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0), // Rounded edges
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Any Problems? Contact Us!',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),

        SizedBox(
          height: 75,
          child: InkWell(
            onTap: () {
              // Handle the tap event for the blue box
              print("box3 tapped");
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Rounded edges
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: const Center(
                child: Text(
                  'View Payment Details',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 75,
          child: InkWell(
            onTap: () {
              controller.onLogOut();
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Rounded edges
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: const Center(
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        ],
      )
    );
  }
}
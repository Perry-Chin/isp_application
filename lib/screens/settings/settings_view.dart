import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_index.dart';
import '../../common/values/values.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "data"
            ),
            // Obx(() => SwitchListTile(
            //     title: const Text("Dark Mode"),
            //     value: controller.isDarkMode.value,
            //     onChanged: (bool value) {
            //       controller.toggleDarkMode();
            //     },
            //   )
            // ),

            // // Add more settings options here
          ],
        ),
      ),
    );
  }
}

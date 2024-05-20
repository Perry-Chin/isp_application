// settings_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Settings"),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: controller.isDarkMode.value,
                  onChanged: (bool value) {
                    controller.toggleDarkMode();
                  },
                )),
            // Add more settings options here
          ],
        ),
      ),
    );
  }
}

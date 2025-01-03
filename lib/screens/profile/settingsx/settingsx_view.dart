import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/custom/custom_theme.dart';
import '../../../common/routes/routes.dart';
import '../../../common/values/values.dart';
import 'settingsx_index.dart';

class SettingsxPage extends GetView<SettingsxController> {
  const SettingsxPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
          const SizedBox(width: 8),
          Text("Settings", style: CustomTextTheme.darkTheme.labelMedium),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
      {required String title, required VoidCallback onTap}) {
    return SizedBox(
      height: 75,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0), // Rounded edges
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.2), // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the controller to ensure it is instantiated
    final SettingsxController controller = Get.put(SettingsxController());

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColor.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
        child: Column(
          children: [
            _buildSettingsOption(
              title: 'Any Problems? Contact Us!',
              onTap: () {
                contctpg(Get.context!);
              },
            ),
            _buildSettingsOption(
              title: 'View Payment Details',
              onTap: () => Get.toNamed(AppRoutes.payment),
            ),
            _buildSettingsOption(
              title: 'About Us',
              onTap: () => Get.toNamed(AppRoutes.aboutus),
            ),
            _buildSettingsOption(
              title: 'Logout',
              onTap: () {
                controller.onLogOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/values/values.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
          const SizedBox(width: 8),
          Text(
            "About Us",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColor.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_bg.png',
                  width: 150, // Increased width
                  height: 150, // Increased height
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                "Created by five NYP business students, FurFriends is a Singapore-based pet services mobile application with the goal of providing professional local pet services to pet owners conveniently and securely.",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                "When asking pet owners about challenges they face while taking care of their pets, they find looking for good local pet services an obstacle. Therefore, we came up with a one-stop solution: everything related to pet services in one app.",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                "Honourable Mentions: Erika, Paris Putri Rosli, Esther, Meow, Reanne, Ashlyn, Valen, Pete, Meri, Ms, Wyna - for helping out in the process of making improvements during the creation of FurFriends!",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

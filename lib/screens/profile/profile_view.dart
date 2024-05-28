import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/values/values.dart';
import '../settingsx/settingsx_index.dart';
import 'profile_index.dart';
import '../editProfile/edit_profile_index.dart'; // Import the edit profile module

class ProfilePage extends GetView<ProfileController> {
  
  const ProfilePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Profile"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: profileView(context),
    );
  }

  Widget profileView(BuildContext context) {

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        final photoUrl = controller.user.value?.photourl;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.secondaryColor, // Blue border color
                              width: 4.0, // Width of the border
                            ),
                          ),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/profile.png", // Placeholder image while loading
                              image: photoUrl?.isNotEmpty == true
                                ? photoUrl!
                                : "assets/images/profile.png",  // Image URL
                              fadeInDuration: const Duration(
                                  milliseconds: 500), // Fade-in duration
                              fit: BoxFit.cover,
                              width: 100.w, // Image width
                              height: 100.w, // Image height
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      "assets/images/profile.png"), // Error placeholder image
                            ),
                          ),
                        );
                      }),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Get.to(() => SettingsxPage(),
                              binding: SettingsxBinding());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Get.to(() => const EditProfilePage(),
                              binding: EditProfileBinding());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Text(
                          controller.user.value?.username ?? 'Username',
                          style: const TextStyle(fontSize: 18),
                        );
                      }),
                      const SizedBox(width: 8),
                      _buildRatingRectangle(controller),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ];
      },
      body: _buildReviewSection(),
    );
  }

  Widget _buildRatingRectangle(ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 7.0),
      child: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.user.value?.rating?.toStringAsFixed(1) ?? '4.6',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.star,
              color: Colors.white,
              size: 16,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildReviewSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Text(
              'Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildReviewsTab(),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Provider'),
                Tab(text: 'Requester'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                ReviewsList(reviewsType: 'All'),
                ReviewsList(reviewsType: 'Provider'),
                ReviewsList(reviewsType: 'Requester'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
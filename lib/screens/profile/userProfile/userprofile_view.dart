import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/values/values.dart';
import '../profile_allreviews.dart';
import 'userprofile_index.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("User Profile"),
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
      body: profileView(context),
    );
  }

  Widget profileView(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final photoUrl = controller.user.value?.photourl;
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.secondaryColor,
                            width: 4.0,
                          ),
                        ),
                        child: ClipOval(
                          child: photoUrl != null && photoUrl.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  placeholder: AppImage.profile,
                                  image: photoUrl,
                                  fadeInDuration:
                                      const Duration(milliseconds: 100),
                                  fit: BoxFit.cover,
                                  width: 90.w,
                                  height: 90.w,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      AppImage.profile,
                                      fit: BoxFit.cover,
                                      width: 90.w,
                                      height: 90.w,
                                    );
                                  },
                                )
                              : Image.asset(
                                  AppImage.profile,
                                  fit: BoxFit.cover,
                                  width: 90.w,
                                  height: 90.w,
                                ),
                        ),
                      );
                    }),
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
                        _buildRatingRectangle(),
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
      ),
    );
  }

  Widget _buildRatingRectangle() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 7.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.user.value?.rating?.toStringAsFixed(1) ?? '0.0',
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
        ),
      );
    });
  }

  Widget _buildReviewSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Row(
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
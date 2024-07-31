import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/custom/custom_theme.dart';
import '../../../common/values/values.dart';
import 'reviews_index.dart';

class DetailReviewView extends GetView<DetailReviewController> {
  const DetailReviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
                image: AssetImage(AppImage.logo), width: 35, height: 35),
            const SizedBox(width: 8),
            Text(
              "Reviews",
              style: CustomTextTheme.darkTheme.labelMedium,
            ),
          ],
        ),
        actions: [
          Obx(
            () => (controller.hasAlreadyReviewed.value ||
                    controller.status != 'Completed')
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => controller.addReview(context),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => _buildRatingSummary()),
            _buildReviewsTab(),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: const [
                  ReviewList(tabType: 'All'),
                  ReviewList(tabType: 'Provider'),
                  ReviewList(tabType: 'Requester'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.averageRating.value.toStringAsFixed(2),
                  style: GoogleFonts.poppins(
                      fontSize: 44, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < controller.averageRating.value.floor()
                          ? AppColor.secondaryColor
                          : Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
                Text(
                  '${controller.totalReviews.value} ratings',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildRatingBars(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBars() {
    return Column(
      children: List.generate(5, (index) {
        int starCount = 5 - index;
        int reviewCount = controller.ratingCounts[starCount] ?? 0;
        double percentage = controller.totalReviews.value > 0
            ? reviewCount / controller.totalReviews.value
            : 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text('$starCount', style: GoogleFonts.poppins(fontSize: 12)),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColor.secondaryColor),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
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
        controller: controller.tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.poppins(),
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
    );
  }
}

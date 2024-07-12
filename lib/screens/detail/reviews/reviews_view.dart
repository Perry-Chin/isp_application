import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/custom/custom_theme.dart';
import '../../../common/values/values.dart';
import 'reviews_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DetailReviewView extends GetView<DetailReviewController> {
  const DetailReviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
            const SizedBox(width: 8),
            Text(
              "Reviews",
              style: CustomTextTheme.darkTheme.labelMedium
            ),
          ],
        ),
        // Add rating button
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => controller.addReview(context)
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            Container(
              color: AppColor.backgroundColor,
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _buildRatingSummary(),
                        ),
                        SliverFillRemaining(
                          child: SmartRefresher(
                            controller: controller.refreshController,
                            onRefresh: controller.onRefresh,
                            onLoading: controller.onLoading,
                            child: _buildReviewsList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      }),
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
                  controller.averageRating.value.toStringAsFixed(1),
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

  Widget _buildReviewsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.reviews.length,
      itemBuilder: (context, index) {
        final review = controller.reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.secondaryColor,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: review.photoUrl != null
                    ? NetworkImage(review.photoUrl!)
                    : null,
                child: review.photoUrl == null
                    ? Text(review.username?[0] ?? 'A')
                    : null,
              ),
            ),
            title: Row(
              children: [
                Text(review.username ?? 'Anonymous', style: GoogleFonts.poppins()),
                const Spacer(),
                Text(controller.formatDate(review.timestamp),
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (starIndex) => Icon(
                      Icons.star,
                      color: starIndex < review.rating
                          ? AppColor.secondaryColor
                          : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(review.reviewText, style: GoogleFonts.poppins()),
              ],
            ),
          ),
        );
      },
    );
  }
}

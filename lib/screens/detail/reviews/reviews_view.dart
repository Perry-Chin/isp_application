
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/data/data.dart';
import '../../../common/theme/custom/custom_theme.dart';
import '../../../common/values/values.dart';
import 'reviews_controller.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => _buildRatingSummary()),
            Expanded(
              child: _buildReviewsList(),
            ),
          ],
        ),
      )
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
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SmartRefresher(
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            controller: controller.refreshController,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var review = controller.reviewList[index].data();
                        var userData = snapshot.data?[review.toUid];
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
                                backgroundImage: userData!.photourl != null
                                    ? NetworkImage(userData.photourl!)
                                    : null,
                                child: userData.photourl == null
                                    ? Text(userData.username?[0] ?? 'A')
                                    : null,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(userData.username ?? "", style: GoogleFonts.poppins()),
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
                                Text(review.review, style: GoogleFonts.poppins()),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: controller.reviewList.length
                    )
                  ),
                )
              ],
            ),
          );
        }
      }
    );
  }
}

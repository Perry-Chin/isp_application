import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/values/values.dart';
import 'detail_reviews_controller.dart';

class DetailReviewView extends GetView<DetailReviewController> {
  const DetailReviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews & Ratings'),
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          color: AppColor.backgroundColor,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: _buildRatingSummary(),
                ),
              ];
            },
            body: Expanded(child: _buildReviewsList()),
          ),
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
                  controller.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < controller.averageRating.floor()
                          ? AppColor.secondaryColor
                          : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                Text('${controller.totalReviews} ratings'),
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
              Text('$starCount'),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColor.secondaryColor),
                  minHeight: 8,
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
                Text(review.username ?? 'Anonymous'),
                const Spacer(),
                Text(controller.formatDate(review.timestamp),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
                Text(review.reviewText),
              ],
            ),
          ),
        );
      },
    );
  }
}

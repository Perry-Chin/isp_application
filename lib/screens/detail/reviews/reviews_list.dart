import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../common/data/data.dart';
import '../../../common/values/values.dart';
import 'reviews_index.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  Widget reviewList(review, userData, controller) {
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
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailReviewController>();
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return SmartRefresher(
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoading,
          controller: controller.refreshController,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var review = controller.reviewList[index].data();
                      var userData = userDataMap[
                        review.fromUid == controller.requested_id
                          ? review.toUid
                          : review.fromUid
                      ];
                      return reviewList(review, userData, controller);
                    },
                    childCount: controller.reviewList.length
                  )
                ),
              ),
            ],
          )
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../common/values/values.dart';
import '../profile/profile_controller.dart';

class ReviewsList extends StatefulWidget {
  final String reviewsType;

  const ReviewsList({required this.reviewsType, Key? key}) : super(key: key);

  @override
  _ReviewsListState createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  final ProfileController profileController = Get.find<ProfileController>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String sortType = 'Newest';

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    await profileController.fetchReviews(widget.reviewsType);
    _refreshController.refreshCompleted();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Newest'),
                onTap: () {
                  setState(() {
                    sortType = 'Newest';
                    profileController.reviews
                        .sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Oldest'),
                onTap: () {
                  setState(() {
                    sortType = 'Oldest';
                    profileController.reviews
                        .sort((a, b) => a.timestamp.compareTo(b.timestamp));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Highest Rating'),
                onTap: () {
                  setState(() {
                    sortType = 'Highest Rating';
                    profileController.reviews
                        .sort((a, b) => b.rating.compareTo(a.rating));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Lowest Rating'),
                onTap: () {
                  setState(() {
                    sortType = 'Lowest Rating';
                    profileController.reviews
                        .sort((a, b) => a.rating.compareTo(b.rating));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.reviews.isEmpty) {
        return const Center(
          child: Text(
            'No Reviews',
            style: TextStyle(fontSize: 18),
          ),
        );
      } else {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _showSortOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(sortType), // Update button text dynamically
                ),
              ],
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _fetchReviews,
                header: const WaterDropHeader(),
                child: ListView.builder(
                  itemCount: profileController.reviews.length,
                  itemBuilder: (context, index) {
                    final review = profileController.reviews[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              // border: Border.all(
                              //   color: AppColor.secondaryColor,
                              //   width: 2.0,
                              // ),
                            ),
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/profile.png",
                                image: review.fromPhotoUrl ??
                                    "assets/images/profile.png",
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error,
                                        stackTrace) =>
                                    Image.asset("assets/images/profile.png"),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.fromUsername ?? 'Anonymous',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      Icons.star,
                                      color: starIndex < review.rating
                                          ? AppColor.secondaryColor
                                          : Colors.grey.shade300,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(review.reviewText),
                                const SizedBox(height: 8),
                                // Text(
                                //   // _formatTimestamp(review.timestamp),
                                //   style: const TextStyle(
                                //       color: Colors.grey, fontSize: 12),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  // Update the method to accept DateTime instead of Timestamp
  String _formatTimestamp(DateTime timestamp) {
    final date = timestamp;
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}

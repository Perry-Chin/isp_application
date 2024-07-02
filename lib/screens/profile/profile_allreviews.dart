import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../common/values/values.dart';
import '../profile/profile_controller.dart';

class ReviewsList extends StatefulWidget {
  final String reviewsType;

  const ReviewsList({required this.reviewsType, Key? key}) : super(key: key);

  @override
  State<ReviewsList> createState() => _ReviewsListState();
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
    _sortReviews();
    _refreshController.refreshCompleted();
  }

  void _sortReviews() {
    switch (sortType) {
      case 'Newest':
        profileController.reviews
            .sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'Oldest':
        profileController.reviews
            .sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'Highest Rating':
        profileController.reviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rating':
        profileController.reviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
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
                    _sortReviews();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Oldest'),
                onTap: () {
                  setState(() {
                    sortType = 'Oldest';
                    _sortReviews();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Highest Rating'),
                onTap: () {
                  setState(() {
                    sortType = 'Highest Rating';
                    _sortReviews();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Lowest Rating'),
                onTap: () {
                  setState(() {
                    sortType = 'Lowest Rating';
                    _sortReviews();
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
                  child: Text(sortType),
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
                          CircleAvatar(
                            radius: 28.0,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: review.photoUrl != null &&
                                      review.photoUrl!.isNotEmpty
                                  ? FadeInImage.assetNetwork(
                                      placeholder: AppImage.profile,
                                      image: review.photoUrl!,
                                      fadeInDuration:
                                          const Duration(milliseconds: 100),
                                      fit: BoxFit.cover,
                                      width: 54.0,
                                      height: 54.0,
                                    )
                                  : Image.asset(AppImage.profile),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.username ?? 'Anonymous',
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
                                Text(
                                  review.isReceived ? 'Received' : 'Given',
                                  style: TextStyle(
                                    color: review.isReceived
                                        ? Colors.green
                                        : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
}

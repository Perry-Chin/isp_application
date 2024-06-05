import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    profileController.fetchReviews(widget.reviewsType);
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
        return Center(
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
                  child: const Text('Sort'),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
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
                            backgroundColor: Colors.grey.shade200,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.fromUid,
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

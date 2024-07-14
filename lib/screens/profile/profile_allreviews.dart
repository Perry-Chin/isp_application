import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../common/values/values.dart';
import '../profile/profile_controller.dart';

class ReviewsList extends StatefulWidget {
  final String reviewsType;
  final String? userId;

  const ReviewsList({required this.reviewsType, this.userId, Key? key})
      : super(key: key);

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  final ProfileController profileController = Get.find<ProfileController>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.fetchUserReviews(widget.userId);
      profileController.filterReviews(widget.reviewsType);
    });
  }

  Future<void> _onRefresh() async {
    try {
      await profileController.fetchUserReviews();
    } catch (e) {
      print('Error refreshing reviews: $e');
    } finally {
      _refreshController.refreshCompleted();
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
                title: Text('Newest', style: GoogleFonts.poppins()),
                onTap: () {
                  profileController.sortReviews('Newest');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Oldest', style: GoogleFonts.poppins()),
                onTap: () {
                  profileController.sortReviews('Oldest');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Highest Rating', style: GoogleFonts.poppins()),
                onTap: () {
                  profileController.sortReviews('Highest Rating');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Lowest Rating', style: GoogleFonts.poppins()),
                onTap: () {
                  profileController.sortReviews('Lowest Rating');
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
      if (profileController.filteredReviews.isEmpty) {
        return Center(
          child: Text(
            'No Reviews',
            style: GoogleFonts.poppins(fontSize: 18),
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
                  child: Text(
                    profileController.currentSortType.value,
                    style: GoogleFonts.poppins()
                  ),
                ),
              ],
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: const WaterDropHeader(),
                child: ListView.builder(
                  itemCount: profileController.filteredReviews.length,
                  itemBuilder: (context, index) {
                    final review = profileController.filteredReviews[index];
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
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
                                Text(review.reviewText, style: GoogleFonts.poppins()),
                                // const SizedBox(height: 8),
                                // Text(
                                //   'Service Type: ${review.serviceType.capitalize}',
                                //   style: TextStyle(
                                //     color: review.serviceType.toLowerCase() ==
                                //             'provider'
                                //         ? Colors.blue
                                //         : Colors.green,
                                //     fontWeight: FontWeight.bold,
                                //   ),
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
}

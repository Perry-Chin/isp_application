import 'package:flutter/material.dart';
import '../../common/values/values.dart';

class ReviewsList extends StatefulWidget {
  final String reviewsType;

  const ReviewsList({required this.reviewsType, Key? key}) : super(key: key);

  @override
  _ReviewsListState createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  List<Map<String, dynamic>> reviews = [];
  String sortType = 'Newest';

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  void fetchReviews() {
    // Hardcoded data for demonstration
    setState(() {
      reviews = [
        {
          'id': 1,
          'user': 'User1',
          'date': '2022-01-01',
          'review': 'Review 1',
          'rating': 4,
        },
        {
          'id': 2,
          'user': 'User2',
          'date': '2022-02-01',
          'review': 'Review 2',
          'rating': 5,
        },
        {
          'id': 3,
          'user': 'User3',
          'date': '2022-03-01',
          'review': 'Review 3',
          'rating': 3,
        },
      ];
      sortReviews();
    });
  }

  void sortReviews() {
    if (sortType == 'Newest') {
      reviews
          .sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    } else if (sortType == 'Oldest') {
      reviews
          .sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
    } else if (sortType == 'Highest Rating') {
      reviews
          .sort((a, b) => (b['rating'] as int).compareTo(a['rating'] as int));
    } else if (sortType == 'Lowest Rating') {
      reviews
          .sort((a, b) => (a['rating'] as int).compareTo(b['rating'] as int));
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
                    sortReviews();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Oldest'),
                onTap: () {
                  setState(() {
                    sortType = 'Oldest';
                    sortReviews();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Highest Rating'),
                onTap: () {
                  setState(() {
                    sortType = 'Highest Rating';
                    sortReviews();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Lowest Rating'),
                onTap: () {
                  setState(() {
                    sortType = 'Lowest Rating';
                    sortReviews();
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _showSortOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColor.secondaryColor, // Same color as AppBar
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              child: Text(sortType),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0), // Add padding to the bottom
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: const Offset(0, 3), // x=0, y=3
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
                              reviews[index]['user'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (starIndex) => Icon(
                                  Icons.star,
                                  color: starIndex < reviews[index]['rating']
                                      ? AppColor.secondaryColor
                                      : Colors.grey.shade300,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(reviews[index]['review']),
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
}

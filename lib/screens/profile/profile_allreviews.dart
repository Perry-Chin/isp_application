import 'package:flutter/material.dart';

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
        {'id': 1, 'user': 'User1', 'date': '2022-01-01', 'review': 'Review 1'},
        {'id': 2, 'user': 'User2', 'date': '2022-02-01', 'review': 'Review 2'},
        {'id': 3, 'user': 'User3', 'date': '2022-03-01', 'review': 'Review 3'},
      ];
      sortReviews();
    });
  }

  void sortReviews() {
    if (sortType == 'Newest') {
      reviews.sort((a, b) => b['date'].compareTo(a['date']));
    } else {
      reviews.sort((a, b) => a['date'].compareTo(b['date']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton<String>(
              value: sortType,
              items: <String>['Newest', 'Oldest'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  sortType = newValue!;
                  sortReviews();
                });
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(reviews[index]['user']),
                subtitle: Text(reviews[index]['review']),
                trailing: Text(reviews[index]['date']),
              );
            },
          ),
        ),
      ],
    );
  }
}

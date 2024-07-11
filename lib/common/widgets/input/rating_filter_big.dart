import 'package:flutter/material.dart';

class StarRatingFilterBig extends StatefulWidget {
  final int rating;
  final ValueChanged<int?> onChanged;

  const StarRatingFilterBig({
    Key? key,
    required this.rating,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StarRatingFilterBig> createState() => _StarRatingFilterState();
}

class _StarRatingFilterState extends State<StarRatingFilterBig> {
  int? _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) { 
        int starValue = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              // Update _selectedRating directly, no need for the ternary operator
              _selectedRating = starValue; 
              widget.onChanged(_selectedRating);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.star,
              size: 40,
              color: starValue <= (widget.rating) ? Colors.orange : Colors.grey[400],
            ),
          ),
        );
      }),
    );
  }
}
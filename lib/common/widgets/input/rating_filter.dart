import 'package:flutter/material.dart';

class StarRatingFilter extends StatefulWidget {
  final int rating;
  final ValueChanged<int?> onChanged;

  const StarRatingFilter({
    Key? key,
    required this.rating,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StarRatingFilter> createState() => _StarRatingFilterState();
}

class _StarRatingFilterState extends State<StarRatingFilter> {
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
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              Icons.star,
              size: 35,
              color: starValue <= (widget.rating) ? Colors.orange : Colors.grey[400],
            ),
          ),
        );
      }),
    );
  }
}
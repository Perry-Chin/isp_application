import 'package:flutter/material.dart';

import '../values/values.dart';

class Rating extends StatelessWidget {
  final num rating;

  const Rating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.secondaryColor),
      ),
      // Rating
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rating',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.star,
            color: Colors.yellow,
            size: 16,
          ),
        ],
      ),
    );
  }
}
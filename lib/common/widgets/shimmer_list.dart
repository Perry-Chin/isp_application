import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListLoading extends StatelessWidget {
  final int itemCount;

  const ShimmerListLoading({
    required this.itemCount, 
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: itemCount,  // You can change this to match the number of placeholders you want
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.w),
              color: Colors.transparent,
              elevation: 4,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 0.2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

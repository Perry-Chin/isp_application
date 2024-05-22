import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,  // You can change this to match the number of placeholders you want
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Card(
              color: Colors.transparent,
              elevation: 4,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 0.2),
                ),
                child: Column(
                  children: [
                    ListTile(
                      horizontalTitleGap: 12,
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Container(
                        height: 16,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                      subtitle: Container(
                        height: 14,
                        width: 150,
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(width: 2),
                          Container(
                            height: 14,
                            width: 100,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 16,
                            width: 80,
                            color: Colors.grey[300],
                          ),
                          Container(
                            height: 20,
                            width: 50,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

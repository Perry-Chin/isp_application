import 'package:flutter/material.dart';

class TopIndicator extends StatelessWidget {
  const TopIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 5,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
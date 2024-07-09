// Top Indicator (imply scrollable)
import 'package:flutter/material.dart';

Widget topIndicator() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 45,
          height: 5,
          color: Colors.black12,
        ),
      ],
    ),
  );
}
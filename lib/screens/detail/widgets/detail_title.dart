
import 'package:flutter/material.dart';

class DetailTitle extends StatelessWidget {
  const DetailTitle({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 5),
      child: Text(
        name ?? "Service Name",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

Future<dynamic> appLoading(BuildContext context) {
    return showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}
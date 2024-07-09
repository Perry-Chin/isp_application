import 'package:flutter/material.dart';

import '../../values/values.dart';

class CustomTextTheme {
  CustomTextTheme._();

  static TextTheme lightTheme = TextTheme(
    // Used for bold heading text - Most Common
    headlineMedium: const TextStyle().copyWith(
      fontSize: 8,
      fontWeight: FontWeight.w600,
      color: AppColor.lightColor
    ),
  );

  static TextTheme darkTheme = TextTheme(
    // Used for bold heading text - Most Common
    headlineMedium: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColor.darkColor
    ),
  );
}
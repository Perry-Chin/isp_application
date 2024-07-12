import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    titleMedium: GoogleFonts.poppins(
      fontSize: 20,
      color: AppColor.darkColor,
      fontWeight: FontWeight.bold,
    )
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
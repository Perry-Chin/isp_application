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
    labelMedium: GoogleFonts.poppins(
      fontSize: 20,
      color: AppColor.lightColor,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 15,
      color: AppColor.lightColor,
      fontWeight: FontWeight.w500       
    )
  );

  static TextTheme darkTheme = TextTheme(
    // Used for bold heading text - Most Common
    headlineMedium: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColor.darkColor
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 20,
      color: AppColor.darkColor,
      fontWeight: FontWeight.bold,
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../values/values.dart';

class CustomTextFormFieldTheme {
  CustomTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: AppColor.lightColor,
    suffixIconColor: AppColor.lightColor,
    labelStyle: GoogleFonts.poppins().copyWith(fontSize: 15, color: AppColor.lightColor, fontWeight: FontWeight.w400),
    hintStyle: GoogleFonts.poppins().copyWith(fontSize: 14, color: AppColor.hintText),
    errorStyle: GoogleFonts.poppins().copyWith(fontSize: 14, color: AppColor.error, fontWeight: FontWeight.w500),
    floatingLabelStyle: GoogleFonts.poppins().copyWith(fontSize: 18, color: AppColor.lightColor,),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.secondaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.lightColor, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 1, color: AppColor.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 2, color: AppColor.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: AppColor.darkColor,
    suffixIconColor: AppColor.darkColor,
    labelStyle: GoogleFonts.poppins().copyWith(fontSize: 14, color: AppColor.darkColor, fontWeight: FontWeight.w400),
    hintStyle: GoogleFonts.poppins().copyWith(fontSize: 14, color: AppColor.hintText),
    errorStyle: GoogleFonts.poppins().copyWith(fontSize: 14, color: AppColor.error, fontWeight: FontWeight.w600),
    floatingLabelStyle: GoogleFonts.poppins().copyWith(fontSize: 18, color: AppColor.darkColor),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.secondaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.darkColor, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 1, color: AppColor.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 2, color: AppColor.error),
    ),
  );
}
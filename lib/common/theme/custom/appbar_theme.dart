import 'package:flutter/material.dart';

import '../../values/values.dart';

class CustomAppBarTheme {
  CustomAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    toolbarHeight: 60,
    scrolledUnderElevation: 0,
    backgroundColor: AppColor.secondaryColor,
    surfaceTintColor: AppColor.secondaryColor,
    titleTextStyle: TextStyle(
      fontSize: 20,
      color: AppColor.darkColor,
      fontWeight: FontWeight.bold,
    )
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  );
}
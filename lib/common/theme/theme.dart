import 'package:flutter/material.dart';

import 'custom/custom_theme.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: CustomTextTheme.darkTheme,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: CustomAppBarTheme.darkAppBarTheme
  );
}
import 'package:flutter/material.dart';

//final ThemeData lightMode = ThemeData(
//  colorScheme: ColorScheme.light(
//    surface: Colors.grey.shade300,
//    primary: Colors.grey.shade500,
//    secondary: Colors.grey.shade200,
//    tertiary: Colors.white,
//    inversePrimary: Colors.grey.shade900,
//  ),
//);
//



final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

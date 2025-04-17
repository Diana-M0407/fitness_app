import 'package:flutter/material.dart';
import 'light.dart';
import 'dark.dart';

class ThemeProvider extends ChangeNotifier {
  // Default theme is light mode
  ThemeData _themeData = lightMode;
 


  // Getter for theme data
  ThemeData get themeData => _themeData;


  // checks if theme is dark
  bool get isDarkMode => themeData == darkMode;

  // sets theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

// toggles theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}



//class ThemeProvider extends ChangeNotifier {
//  bool _isDarkMode = false;
//
//  bool get isDarkMode => _isDarkMode;
//
//  ThemeData get getTheme =>
//      _isDarkMode ? ThemeData.dark() : ThemeData.light();
//
//  get themeData => null;
//
//  void toggleTheme() {
//    _isDarkMode = !_isDarkMode;
//    notifyListeners();
//  }
//}

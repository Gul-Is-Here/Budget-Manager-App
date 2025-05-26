// controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  var primaryColor = Color(0xFF6C5CE7).obs; // Purple
  var secondaryColor = Color(0xFF00CEFF).obs; // Blue
  var accentColor = Color(0xFFFD79A8).obs; // Pink

  // Light theme
  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF6C5CE7),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF6C5CE7),
      secondary: Color(0xFF00CEFF),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  );

  // Dark theme
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF6C5CE7),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF6C5CE7),
      secondary: Color(0xFF00CEFF),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  );

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
  }
}
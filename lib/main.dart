// main.dart
import 'package:budget_manager_app/controllers/nav_controller.dart';
import 'package:budget_manager_app/views/splash_screen.dart';
import 'package:budget_manager_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Budget Manager',
      theme: _themeController.lightTheme,
      darkTheme: _themeController.darkTheme,
      themeMode: _themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MainWrapper extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: navController.currentIndex.value,
        children: navController.pages,
      )),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
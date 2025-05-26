// views/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/theme_controller.dart';

class SettingsView extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Appearance', style: GoogleFonts.poppins()),
            subtitle: Text('Change theme mode'),
            trailing: Obx(
              () => Switch(
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.toggleTheme(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/role_selection.dart';

void main() {
  runApp(const PayCampusApp());
}

class PayCampusApp extends StatelessWidget {
  const PayCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayCampus',
      debugShowCheckedModeBanner: false,
      
      // Light and Dark themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respect system theme preferences
      
      // Launcher Gate
      home: const RoleSelectionScreen(),
    );
  }
}

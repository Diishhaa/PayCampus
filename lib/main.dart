import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/role_selection.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void main() {
  runApp(const PayCampusApp());
}

class PayCampusApp extends StatelessWidget {
  const PayCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'PayCampus',
          debugShowCheckedModeBanner: false,
          
          // Light and Dark themes
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          
          // Launcher Gate
          home: const RoleSelectionScreen(),
        );
      },
    );
  }
}

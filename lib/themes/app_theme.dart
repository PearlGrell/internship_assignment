import 'package:flutter/material.dart';

/// This file defines the app's theme data for light and dark modes.
/// It uses Material 3 design principles and a blue color scheme.
/// /// The `AppTheme` class provides static properties for light and dark themes,
/// /// allowing easy access to the theme data throughout the app.
/// /// The light theme uses a color scheme generated from a seed color (blue),
/// /// while the dark theme is configured with a dark brightness and the same seed color.
/// /// The themes are designed to be used with the MaterialApp widget in Flutter,
/// /// ensuring a consistent look and feel across the application.
/// 
class AppTheme {
  static final ThemeData light =  ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
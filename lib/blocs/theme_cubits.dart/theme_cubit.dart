import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// ThemeCubit is responsible for managing the theme mode of the application.
/// /// It uses a Hive box to store the theme preference and emits the current theme mode.
/// /// The cubit initializes with the theme mode based on the stored preference in the Hive box.
/// /// The cubit provides a method to toggle the theme mode between light and dark.
/// /// The [toggleTheme] method updates the Hive box with the new theme preference
/// /// and emits the new theme mode.
class ThemeCubit extends Cubit<ThemeMode> {
  final Box settingsBox;

  ThemeCubit(this.settingsBox)
      : super(settingsBox.get('isDarkMode', defaultValue: false)
              ? ThemeMode.dark
              : ThemeMode.light);

  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    settingsBox.put('isDarkMode', !isDark);
    emit(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
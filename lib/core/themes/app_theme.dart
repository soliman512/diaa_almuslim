import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zad_almuslim/core/constants/colors.dart';

class AppTheme {
  static const String appFont = 'el-messiri';

  static final ThemeData lightModeTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scrollbarTheme: const ScrollbarThemeData(
      thumbVisibility: WidgetStatePropertyAll(false),
      trackVisibility: WidgetStatePropertyAll(false),
      thickness: WidgetStatePropertyAll(0),
    ),
    scaffoldBackgroundColor: ConstColors.lightMode,

    fontFamily: 'el-messiri',
    appBarTheme: AppBarTheme(
      toolbarHeight: 80,
      elevation: 0,
      surfaceTintColor: ConstColors.lightMode,

      scrolledUnderElevation: 3.0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 34, color: ConstColors.mainColor),
      titleMedium: TextStyle(fontSize: 22, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12),
      bodyMedium: TextStyle(fontSize: 16),
      bodyLarge: TextStyle(fontSize: 18),
    ),
  );

  static final ThemeData darkModeTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scrollbarTheme: const ScrollbarThemeData(
      thumbVisibility: WidgetStatePropertyAll(false),
      trackVisibility: WidgetStatePropertyAll(false),
      thickness: WidgetStatePropertyAll(0),
    ),
    scaffoldBackgroundColor: ConstColors.darkMode,
    fontFamily: 'el-messiri',
    appBarTheme: AppBarTheme(
      toolbarHeight: 80,
      surfaceTintColor: ConstColors.darkMode,

      scrolledUnderElevation: 3.0,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.dark, // For iOS
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 34, color: ConstColors.mainColor),
      titleMedium: TextStyle(fontSize: 22, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12),
      bodyMedium: TextStyle(fontSize: 16),
      bodyLarge: TextStyle(fontSize: 18),
    ),
  );
}


/*
import 'package:flutter/material.dart';

class AppTheme {
  // Define the font name here once to avoid typos (أخطاء إملائية)
  static const String appFont = 'el-messiri';

  // 1. Light Mode Configuration
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: appFont,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 20, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
    ),
  );

  // 2. Dark Mode Configuration
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: appFont,
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark grey
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
  );
}
 */
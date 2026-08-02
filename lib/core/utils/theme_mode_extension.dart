import 'package:flutter/material.dart';

extension ThemeModeExtension on BuildContext {
  bool get isDarkMode =>  Theme.of(this).brightness == Brightness.dark;
  Size get screenSize =>  MediaQuery.sizeOf(this);

}
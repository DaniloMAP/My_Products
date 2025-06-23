import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  int get gridCrossAxisCount {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    return 2;
  }
}

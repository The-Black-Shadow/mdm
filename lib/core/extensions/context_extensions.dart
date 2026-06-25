import 'package:flutter/material.dart';

// >>> ContextExtensions =======================
// Shorthand getters on BuildContext for common theme and layout lookups
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;
}
// <<< ContextExtensions =======================

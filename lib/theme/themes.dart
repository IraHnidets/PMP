import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.indigo,
    onPrimary: Colors.white,
    secondary: Colors.amber,
    onSecondary: Colors.black,
    background: Colors.grey[100]!,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  // ...
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.indigo[200]!,
    onPrimary: Colors.black,
    secondary: Colors.amber[700]!,
    onSecondary: Colors.white,
    background: Colors.grey[900]!,
    onBackground: Colors.white,
    surface: Colors.grey[800]!,
    onSurface: Colors.white,
  ),
  // ...
);




import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.grey[800])),
  primaryColor: Colors.black,
  cardColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200], // Light background for text fields
    hintStyle:
        TextStyle(color: Colors.grey[600], fontSize: 18), // Hint text color
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Main text color
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white)),
  cardColor: Colors.grey,
  primaryColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[700], // Dark background for text fields
    hintStyle:
        TextStyle(color: Colors.grey[50], fontSize: 18), // Hint text color
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Main text color
  ),
);

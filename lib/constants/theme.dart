import 'package:flutter/material.dart';

/// Application-wide theme settings for consistent styling.
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  useMaterial3: true,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
);

/// Special style for the large "Cook!" button.
final ButtonStyle cookButtonStyle = ElevatedButton.styleFrom(
  shape: const CircleBorder(),
  padding: const EdgeInsets.all(32),
  backgroundColor: Colors.deepOrange,
  foregroundColor: Colors.white,
  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
);

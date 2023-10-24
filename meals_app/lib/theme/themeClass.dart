import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    accentColor: Colors.amber,
    primaryColor: Colors.pink,
    appBarTheme: const AppBarTheme(
      color: Colors.pink,
    ),
    splashColor: Colors.pink.shade300,
    fontFamily: 'Raleway',
    highlightColor: Colors.pink.shade300,
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      subtitle2: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 25,
        color: Colors.white70,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData();
}

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black
      )
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black45,
    ),
    headline2: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black45,
    ),
  ),

  //textTheme: ,
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
            color: Colors.white
        )
    ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white54,
    ),
    headline2: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white54,
    ),
  ),
  //textTheme: ,
);
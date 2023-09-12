import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final loftTheme = ThemeData(
  primaryColor: Colors.teal[700],
  hintColor: Colors.teal[700],
  scaffoldBackgroundColor: Color(0xFFCADAC5),
  appBarTheme: const AppBarTheme(
    color: Colors.teal,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    ),
    bodyText2: TextStyle(
      fontSize: 16.0,
      color: Colors.black87,
    ),
  ),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.teal[700]!),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.teal[700]!),
    ),
  ),
);
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  hintColor: Colors.blueAccent,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 16.0,
      color: Colors.black87,
    ),
  ),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    ),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  hintColor: Colors.grey[50],
  scaffoldBackgroundColor: Color(121212),
  appBarTheme: AppBarTheme(
    color: Colors.grey[900],
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),
    bodyText2: TextStyle(
      fontSize: 16.0,
      color: Colors.white70,
    ),
  ),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[900]!),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white60),
    ),
  ),
);

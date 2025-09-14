import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static final Color _lightPrimaryColor = Colors.blueGrey.shade800;
  static final Color _lightOnPrimaryColor = Colors.white;
  static final Color _lightSecondaryColor = Colors.blue.shade500;

  static final Color _darkPrimaryColor = Colors.grey.shade900;
  static final Color _darkOnPrimaryColor = Colors.white;
  static final Color _darkSecondaryColor = Colors.blue.shade400;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade100,
    primaryColor: _lightPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      onPrimary: _lightOnPrimaryColor,
      secondary: _lightSecondaryColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimaryColor,
      foregroundColor: _lightOnPrimaryColor,
      elevation: 4,
      titleTextStyle: GoogleFonts.lato(
        color: _lightOnPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _lightPrimaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: _lightOnPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: _lightPrimaryColor,
      unselectedItemColor: Colors.grey.shade500,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: _darkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      onPrimary: _darkOnPrimaryColor,
      secondary: _darkSecondaryColor,
      onSecondary: Colors.black,
      surface: Colors.grey.shade800,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkPrimaryColor,
      foregroundColor: _darkOnPrimaryColor,
      elevation: 4,
      titleTextStyle: GoogleFonts.lato(
        color: _darkOnPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _darkSecondaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkSecondaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: _darkSecondaryColor,
      unselectedItemColor: Colors.grey.shade400,
    ),
  );
}

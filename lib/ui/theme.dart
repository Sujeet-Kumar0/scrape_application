import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the primary and secondary colors
final Color primaryColor = Color(0xFF00BDD6);
final Color secondaryColor = Color(0xFF8353E2);

// Define the text theme
final TextTheme _textTheme = TextTheme(
  displayLarge: GoogleFonts.epilogue(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black, // Adjust as per design
  ),
  titleLarge: GoogleFonts.epilogue(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Adjust as per design
  ),
  displayMedium: GoogleFonts.epilogue(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black, // Adjust as per design
  ),
  // Add more styles for other headings if needed
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    color: Colors.black87, // Adjust as per design
  ),
  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    color: Colors.black87, // Adjust as per design
  ),
  bodySmall: GoogleFonts.inter(
    color: Colors.black87, // Adjust as per design
  ),
);

// Define the main theme
final ThemeData myTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor),
  // primaryColor: primaryColor,
  // secondaryColor: secondaryColor,
  scaffoldBackgroundColor: Colors.white, // Adjust as per design
  textTheme: _textTheme.apply(
    displayColor: Colors.black, // Adjust as per design
    bodyColor: Colors.black, // Adjust as per design
  ),
  // Define other theme properties as needed
);

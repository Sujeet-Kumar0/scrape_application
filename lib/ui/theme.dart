import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the primary and secondary colors
final Color primaryColor = Color(0xFF55AB33);
final Color secondaryColor = Color(0xFF81CA33);
final Color tertiryColor = Color(0x0D0D0D);

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
  bodyLarge: GoogleFonts.epilogue(
    fontSize: 16,
    color: Colors.black87, // Adjust as per design
  ),
  bodyMedium: GoogleFonts.epilogue(
    fontSize: 14,
    color: Colors.black87, // Adjust as per design
  ),
  bodySmall: GoogleFonts.epilogue(
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
  scaffoldBackgroundColor: Colors.white,
  textTheme: _textTheme.apply(
    displayColor: Colors.black,
    bodyColor: Colors.black,
  ),
);

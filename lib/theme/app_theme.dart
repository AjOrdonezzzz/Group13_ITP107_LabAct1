import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xff3777FF);
  static const Color background = Color(0xffFFFFFF);
  static const Color textDark = Color(0xff1B1C15);
  static const Color muted = Color(0xff3C3C43);
  static const Color border = Color(0xffE2E8F0);
  static const Color surface = Color(0xffE8EEFF);


  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,

      colorScheme: const ColorScheme.light( 
        primary: primary, 
        surface: surface, 
        onSurface: textDark,
      ),

      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28, 
          fontWeight: FontWeight.bold, 
          color: textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w600, 
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 14, 
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14, 
          color: muted,
        )
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: muted, fontSize: 14),
        labelStyle: const TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.w500),
        // Default border state
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        // Active/Focused field state
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),

      // Global Button Theme (Matches the large Login/Register/Logout actions)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52), // Full width matching design
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card/Container Theme (For Quick Actions and Recent Activity items)
      cardTheme: CardThemeData(
        color: surface  ,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 0.5),
        ),
      ),
    );   
  }
}
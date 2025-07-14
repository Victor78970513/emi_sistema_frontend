import 'package:flutter/material.dart';
import '../constants/emi_colors.dart';

class EMITheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: EMIColors.primaryBlue,
        brightness: Brightness.light,
      ),

      // Colores principales
      primaryColor: EMIColors.primaryBlue,
      primarySwatch: MaterialColor(
        // ignore: deprecated_member_use
        EMIColors.primaryBlue.value,
        <int, Color>{
          50: EMIColors.lightBlue,
          100: EMIColors.lightBlue,
          500: EMIColors.primaryBlue,
          700: EMIColors.darkBlue,
          900: EMIColors.darkBlue,
        },
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: EMIColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EMIColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: EMIColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: EMIColors.primaryBlue,
          side: BorderSide(color: EMIColors.primaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: EMIColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Card
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EMIColors.veryLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: EMIColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: EMIColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: EMIColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: EMIColors.errorRed),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // ProgressIndicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: EMIColors.primaryBlue,
        linearTrackColor: EMIColors.lightGray,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: EMIColors.lightGray,
        thickness: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: EMIColors.veryLightGray,
        selectedColor: EMIColors.primaryBlue,
        labelStyle: TextStyle(color: EMIColors.primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: EMIColors.primaryBlue,
        unselectedItemColor: EMIColors.mediumGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // TabBar
      tabBarTheme: TabBarTheme(
        labelColor: EMIColors.primaryBlue,
        unselectedLabelColor: EMIColors.mediumGray,
        indicator: BoxDecoration(
          color: EMIColors.primaryBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: EMIColors.primaryBlue,
        contentTextStyle: TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

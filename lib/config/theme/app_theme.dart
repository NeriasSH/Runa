import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const seedColor = Color(0xFF1E1C36);

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    // Componentes específicos
    appBarTheme: AppBarTheme(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : seedColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.white,
      ),
      iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.white),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue[600],
      foregroundColor: Colors.white,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: isDarkMode ? Colors.blue[200] : seedColor,
      tileColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
    ),

    // Textos
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      bodyLarge: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
    ),
  );

  static void setSystemUIOverlayStyle({required bool isDarkMode}) {
    final themeBrightness = isDarkMode ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: themeBrightness,
        statusBarIconBrightness: themeBrightness,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: themeBrightness,
      ),
    );
  }
}

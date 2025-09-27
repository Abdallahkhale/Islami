import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';

abstract class themeManger {
  static ThemeData themeData = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsApp.primaryColor,
      
      iconTheme: IconThemeData(
        
        color: ColorsApp.gold),
      titleTextStyle: TextStyle(
        fontFamily: 'Janna',
        fontSize: 20,
        color: ColorsApp.gold,
        fontWeight: FontWeight.w700,
      ),
    ),
    scaffoldBackgroundColor: ColorsApp.primaryColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Janna',
        fontSize: 24,
        color: ColorsApp.black,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Janna',
        fontSize: 14,
        color: ColorsApp.black,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
        backgroundColor: ColorsApp.gold,
        selectedItemColor: ColorsApp.white,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: false,
        selectedLabelStyle:TextStyle(
          fontFamily: 'Janna',
          fontSize: 12,
          fontWeight: FontWeight.w700
        ),
    ),
  );
}
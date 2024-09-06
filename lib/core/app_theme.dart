import 'package:flutter/material.dart';
import '../core/value_manger.dart';

import 'color_manger.dart';
import 'font_manger.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      // colorSchemeSeed: Colors.green,
      colorScheme: ColorManager.lightColorScheme,
      cardTheme: CardTheme(
          elevation: AppSize.s4,
          shadowColor: ColorManager.lightColorScheme.shadow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: AppSize.s4,
      ),
      buttonTheme: ButtonThemeData(
          splashColor: ColorManager.lightColorScheme.primary,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s14),
          ))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s14)))),
      textTheme: AppTextStyle.textThemeLight,

      inputDecorationTheme: InputDecorationTheme(
          //write focus border and text style    later
          contentPadding: const EdgeInsets.all(Apppadding.p8),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: AppSize.s1, color: Colors.grey),
              borderRadius: BorderRadius.circular(AppSize.s14))),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      // colorSchemeSeed: Colors.green,
      colorScheme: ColorManager.darkColorScheme,
      cardTheme: CardTheme(
          elevation: AppSize.s4,
          shadowColor: ColorManager.darkColorScheme.shadow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: AppSize.s4,
      ),

      buttonTheme: ButtonThemeData(
          splashColor: ColorManager.darkColorScheme.primary,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s14),
          ))),

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s14)))),

      textTheme: AppTextStyle.textThemeLight,

      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(Apppadding.p8),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: AppSize.s1_5, color: Colors.grey),
              borderRadius: BorderRadius.circular(AppSize.s14))),
    );
  }
}

import 'package:flutter/material.dart';


class FontWeightManger {
  static const FontWeight leastLight = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight mostThickbold = FontWeight.w700;
}

class FontSize {
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s17 = 17.0;
  static const double s18 = 18.0;
  static const double s19 = 19.0;
  static const double s20 = 20.0;
}

class AppTextStyle {
  static TextTheme textThemeLight = const TextTheme(
    displayLarge: TextStyle(
        fontSize: 112.0,
        fontWeight: FontWeightManger.leastLight,
        textBaseline: TextBaseline.alphabetic),
    displayMedium: TextStyle(
        fontSize: 56.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    displaySmall: TextStyle(
        fontSize: 45.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    headlineLarge: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    headlineMedium: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    headlineSmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeightManger.medium,
        textBaseline: TextBaseline.alphabetic),
    titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: 0.1),
    bodyLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.medium,
        textBaseline: TextBaseline.alphabetic),
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    labelMedium: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    labelSmall: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: 1.5),
  );

  static TextTheme textThemeDark = const TextTheme(
    displayLarge: TextStyle(
        fontSize: 112.0,
        fontWeight: FontWeightManger.leastLight,
        textBaseline: TextBaseline.alphabetic),
    displayMedium: TextStyle(
        fontSize: 56.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    displaySmall: TextStyle(
        fontSize: 45.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    headlineLarge: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    headlineMedium: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    headlineSmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeightManger.medium,
        textBaseline: TextBaseline.alphabetic),
    titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: 0.1),
    bodyLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.medium,
        textBaseline: TextBaseline.alphabetic),
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    labelMedium: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic),
    labelSmall: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeightManger.regular,
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: 1.5),
  );
}

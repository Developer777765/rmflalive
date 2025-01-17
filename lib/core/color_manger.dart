import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = Colors.red;
  static Color primaryDark = Colors.purple;
  static Color Scaffoldbackground = const Color.fromARGB(255, 238, 232, 232);
  static Color ScaffoldbackgroundDark = const Color.fromARGB(255, 37, 34, 34);
  static Color demoColor = HexColor.fromHex("#52522");

  static ColorScheme lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff006334),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFA7F5A7),
    onPrimaryContainer: Color(0xFF002106),
    secondary: Color(0xFF526350),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD5E8D0),
    onSecondaryContainer: Color(0xFF101F10),
    tertiary: Color(0xFF39656B),
    onTertiary: Color(0xff10DC79),
    tertiaryContainer: Color(0xFFBCEBF2),
    onTertiaryContainer: Color(0xFF001F23),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFCFDF7),
    onSurface: Color(0xFF1A1C19),
    surfaceContainerHighest: Color(0xFFDEE5D9),
    onSurfaceVariant: Color(0xFF424940),
    outline: Color(0xFF72796F),
    onInverseSurface: Color(0xFFF0F1EB),
    inverseSurface: Color(0xFF2F312D),
    inversePrimary: Color(0xFF8CD88D),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF216C2E),
    outlineVariant: Color(0xFFC2C9BD),
    scrim: Color(0xFF000000),
  );

  static ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8CD88D),
    onPrimary: Color(0xFF00390F),
    primaryContainer: Color(0xFF00531A),
    onPrimaryContainer: Color(0xFFA7F5A7),
    secondary: Color(0xFFB9CCB4),
    onSecondary: Color(0xFF243424),
    secondaryContainer: Color(0xFF3A4B39),
    onSecondaryContainer: Color(0xFFD5E8D0),
    tertiary: Color(0xFFA1CED5),
    onTertiary: Color(0xFF00363C),
    tertiaryContainer: Color(0xFF1F4D53),
    onTertiaryContainer: Color(0xFFBCEBF2),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF1A1C19),
    onSurface: Color(0xFFE2E3DD),
    surfaceContainerHighest: Color(0xFF424940),
    onSurfaceVariant: Color(0xFFC2C9BD),
    outline: Color(0xFF8C9388),
    onInverseSurface: Color(0xFF1A1C19),
    inverseSurface: Color(0xFFE2E3DD),
    inversePrimary: Color(0xFF216C2E),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF8CD88D),
    outlineVariant: Color(0xFF424940),
    scrim: Color(0xFF000000),
  );
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // so opacity with 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}

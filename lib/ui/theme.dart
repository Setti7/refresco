import 'package:flutter/material.dart';

//import 'package:flutter/material.dart';
//
//final Gradient buttonGradient = LinearGradient(
//  colors: <Color>[
//    Color(0xFFE3521D),
//    Color(0xFFFC7646),
//  ],
//);

class AppColors {
  static MaterialColor get primary => MaterialColor(0xFF2962FF, {
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(0xFF2196F3),
        600: Color(0xFF1E88E5),
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1)
      });

  static Color get accent => Color(0xffff2962);

  static Color get scaffoldBackground => Color(0xFFEFF4F7);

  static Color get bottomSheetHandle => Colors.grey[300];

  static Color get bottomSheetHandleDark => Colors.grey[700];

  static Color get cardSurface => Color(0xFFFAFAFA);
}

class AppThemes {
  static ThemeData get themeData => ThemeData(
        primarySwatch: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        accentColor: AppColors.accent,
        buttonTheme: AppThemes.buttonTheme,
        accentTextTheme: AppThemes.accentTextTheme,
        inputDecorationTheme: AppThemes.inputDecorationTheme,
        cardTheme: AppThemes.cardTheme,
      );

  static ButtonThemeData get buttonTheme => ButtonThemeData(
        height: 48,
        textTheme: ButtonTextTheme.primary,
      );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
        ),
      );

  static CardTheme get cardTheme => CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.cardBorderRadius,
        ),
      );

  static TextTheme get accentTextTheme => TextTheme(
        bodyText1: TextStyle(color: AppColors.primary),
        bodyText2: TextStyle(color: AppColors.accent),
      );

  static ThemeData get storeCardTheme => ThemeData(
        textTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: cardTheme,
      );
}

class AppShapes {
  static BorderRadius get cardBorderRadius => BorderRadius.circular(8);

  static BorderRadius get inputBorderRadius => BorderRadius.circular(8);

  static BorderRadius get bottomSheetBorderRadius =>
      BorderRadius.vertical(top: Radius.circular(16));

  static double get iconSize => 30;

  static double get cardIconSize => 32;
}

class AppFonts {
  static double get labelFontSize => 20.0;

  static TextStyle get boldPlainHeadline6 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black45,
      );

  static TextStyle get normalPlainHeadline6Smaller => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      );

  static TextStyle get boldPrimaryDarkHeadline6 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.primary[900],
      );
}

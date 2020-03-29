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
  static final MaterialColor primary = MaterialColor(0xFF2962FF, {
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
  static final Color accent = Color(0xffff2962);
  static final Color scaffoldBackground = Color(0xFFEFF4F7);
  static final Color bottomSheetHandle = Colors.grey[300];
  static final Color bottomSheetHandleDark = Colors.grey[700];
  static final Color cardSurface = Color(0xFFFAFAFA);
}

class AppThemes {
  static final buttonTheme = ButtonThemeData(
    height: 48,
    textTheme: ButtonTextTheme.primary,
  );

  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: AppShapes.inputBorderRadius,
    ),
  );

  static final cardTheme = CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: AppShapes.cardBorderRadius,
    ),
  );

  static final accentTextTheme = TextTheme(
    bodyText1: TextStyle(color: AppColors.primary),
    bodyText2: TextStyle(color: AppColors.accent),
  );

  static final boldPlainHeadline6 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black45,
  );

  static final storeCardTheme = ThemeData(
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
  static final double decoratedAppBarWidth = 4.0;
  static final double cardButtonHeight = 36.0;
  static final double labelFontSize = 20.0;
  static final BorderRadius cardBorderRadius = BorderRadius.circular(8);
  static final BorderRadius inputBorderRadius = BorderRadius.circular(8);
  static final BorderRadius bottomSheetBorderRadius =
      BorderRadius.vertical(top: Radius.circular(16));
  static final ShapeBorder bottomSheetShape =
      RoundedRectangleBorder(borderRadius: bottomSheetBorderRadius);
  static final double iconSize = 30;
}

class AppAnimations {
  static final Duration cardImageTransition = Duration(milliseconds: 100);
}

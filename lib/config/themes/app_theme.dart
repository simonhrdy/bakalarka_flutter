import 'package:flutter/material.dart';
import 'package:sportmatter/config/themes/text_theme.dart';

class AppTheme {
  final BuildContext context;

  AppTheme(this.context);

  Color get primary => const Color(0xFF241F55);

  Color get black => const Color(0xFF000000);

  Color get white => const Color(0xFFFFFFFF);

  Color get grey => const Color(0xFFA8A8A8);

  Color get secondary => const Color(0xFF1E1E1E);

  LinearGradient get primaryGradient => LinearGradient(
        colors: [
          primary,
          black,
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );

  SportMatterTextTheme get textTheme => SportMatterTextTheme(
        h1: TextStyle(
          color: white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'PermanentMarker',
        ),
        body: TextStyle(
          color: white,
          fontSize: 20,
          fontFamily: 'Gotham',
        ),
    h2: TextStyle(
      color: white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'Gotham'
    )
      );

  Color get border => white;

  ThemeData get basic {
    return ThemeData();
  }
}

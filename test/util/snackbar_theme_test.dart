import 'package:flutter/material.dart';

import 'color_test.dart';

class SnackBarThemeTest {
  SnackBarThemeData snackBarTheme;
  SnackBarThemeTest(this.snackBarTheme);
  factory SnackBarThemeTest.all() => SnackBarThemeTest(
        SnackBarThemeData(
          contentTextStyle:
              TextStyle(color: ColorTest.lightColorScheme.secondary),
          backgroundColor: ColorTest.darkColorScheme.secondary,
          actionTextColor: ColorTest.lightColorScheme.secondaryContainer,
        ),
      );
  factory SnackBarThemeTest.background() => SnackBarThemeTest(
        SnackBarThemeData(
          backgroundColor: ColorTest.darkColorScheme.secondary,
        ),
      );
  factory SnackBarThemeTest.action() => SnackBarThemeTest(
        SnackBarThemeData(
          actionTextColor: ColorTest.lightColorScheme.secondaryContainer,
        ),
      );
  factory SnackBarThemeTest.empty() => SnackBarThemeTest(
        const SnackBarThemeData(),
      );
}

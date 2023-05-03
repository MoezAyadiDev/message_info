import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:message_info/src/util/color_helper.dart';
import 'package:message_info/src/util/info_colors.dart';

import 'util/color_test.dart';
import 'util/snackbar_theme_test.dart';

void main() {
  group(
    'Content color',
    () {
      test(
        'Return color Surface if theme is dark',
        () {
          Color contentColor = getContentColor(
            isThemeDark: true,
            colorScheme: ColorTest.darkColorScheme,
          );
          expect(contentColor, ColorTest.darkColorScheme.surface);
        },
      );
      test(
        'Return color Surface with opacity if theme is light',
        () {
          Color contentColor = getContentColor(
            isThemeDark: true,
            colorScheme: ColorTest.darkColorScheme,
          );
          expect(contentColor,
              ColorTest.getContentLightColor(ColorTest.darkColorScheme));
        },
      );
    },
  );

  group('Text Style', () {
    late Color contentColor;
    late TextTheme textTheme;
    setUp(() {
      contentColor = getContentColor(
        isThemeDark: false,
        colorScheme: ColorTest.lightColorScheme,
      );
      textTheme = ThemeData().textTheme;
    });
    test(
        'Return TextStyle(color:contentColor) when textColor null and SnackBarTheme null',
        () {
      TextStyle textStyle = getTextStyle(
        snackBarTheme: SnackBarThemeTest.empty().snackBarTheme,
        theme: ThemeData(),
        contentColor: contentColor,
      );
      if (textTheme.bodyMedium != null) {
        expect(textStyle, textTheme.bodyMedium!.copyWith(color: contentColor));
      } else {
        expect(textStyle, const TextStyle().copyWith(color: contentColor));
      }
    });
    test(
        'Return SnackBarTheme.contentTheme(color:contentColor) when textColor null and SnackBarTheme NOT null',
        () {
      var snackBarTheme = SnackBarThemeTest.all().snackBarTheme;
      TextStyle textStyle = getTextStyle(
        snackBarTheme: snackBarTheme,
        theme: ThemeData(),
        contentColor: contentColor,
      );
      expect(
        textStyle,
        snackBarTheme.contentTextStyle!.copyWith(color: contentColor),
      );
    });
    test(
        'Return SnackBarTheme.contentTheme(color:textColor) when textColor NOt null and SnackBarTheme NOT null',
        () {
      var snackBarTheme = SnackBarThemeTest.all().snackBarTheme;
      var infoColor = const InfoColors(textColor: Colors.blue);
      TextStyle textStyle = getTextStyle(
        snackBarTheme: snackBarTheme,
        theme: ThemeData(),
        contentColor: contentColor,
        infoColors: infoColor,
      );
      expect(
        textStyle,
        snackBarTheme.contentTextStyle!.copyWith(color: infoColor.textColor),
      );
    });
  });

  group(
    'Background color',
    () {
      late ColorScheme colorScheme;
      setUp(() {
        colorScheme = ColorTest.lightColorScheme;
      });
      test(
        "Return onSurface when background null snckabarTheme null and is DarkMode",
        () {
          var infoColor = const InfoColors(textColor: Colors.blue);
          var snackBarTheme = SnackBarThemeTest.empty().snackBarTheme;
          var backgroundColor = getBackgroundColor(
            true,
            colorScheme,
            infoColor,
            snackBarTheme,
          );
          expect(
            backgroundColor,
            colorScheme.onSurface,
          );
        },
      );
      test(
        "Return onSurface when background null snckabarTheme null and is not DarkMode",
        () {
          var infoColor = const InfoColors(textColor: Colors.blue);
          var snackBarTheme = SnackBarThemeTest.empty().snackBarTheme;
          var backgroundColor = getBackgroundColor(
            false,
            colorScheme,
            infoColor,
            snackBarTheme,
          );
          expect(
            backgroundColor,
            Color.alphaBlend(
              colorScheme.onSurface.withOpacity(0.80),
              colorScheme.surface,
            ),
          );
        },
      );
    },
  );
}

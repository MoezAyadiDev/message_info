import 'package:flutter/material.dart';
import 'package:message_info/src/util/info_colors.dart';
//Get the default content color

Color getContentColor({
  required bool isThemeDark,
  required ColorScheme colorScheme,
}) {
  return isThemeDark
      ? colorScheme.surface
      : Color.alphaBlend(
          colorScheme.surface.withOpacity(0.80),
          colorScheme.surface,
        );
}

//Get the default text Color
TextStyle getTextStyle({
  required SnackBarThemeData snackBarTheme,
  required ThemeData theme,
  required Color contentColor,
  InfoColors? infoColors,
}) {
  Color textColor = contentColor;
  if (infoColors != null) {
    if (infoColors.textColor != null) {
      textColor = infoColors.textColor!;
    }
  }
  var textStyle = snackBarTheme.contentTextStyle;
  textStyle ??= theme.textTheme.bodyMedium ?? const TextStyle();
  return textStyle.copyWith(color: textColor);
}

//Get the default background
Color getBackgroundColor(
  bool isThemeDark,
  ColorScheme colorScheme,
  InfoColors? infoColors,
  SnackBarThemeData snackBarTheme,
) {
  if (infoColors != null) {
    if (infoColors.backgroundColor != null) {
      return infoColors.backgroundColor!;
    }
  }
  var snackBarBackground = snackBarTheme.backgroundColor;
  if (snackBarBackground != null) return snackBarBackground;
  return isThemeDark
      ? colorScheme.onSurface
      : Color.alphaBlend(
          colorScheme.onSurface.withOpacity(0.80),
          colorScheme.surface,
        );
}

//Get the default background
Color getIconColor(
  InfoColors? infoColors,
  Color contentColor,
) {
  if (infoColors != null) {
    if (infoColors.iconColor != null) {
      return infoColors.iconColor!;
    }
  }
  return contentColor;
}

//Get the default background
Color getTextButtonColor(
  bool isThemeDark,
  ColorScheme colorScheme,
) {
  return colorScheme.inversePrimary;
}

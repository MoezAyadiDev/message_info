import 'package:flutter/widgets.dart';

///The colors of the widget
///
///if `null` all color will be copied from `Snackbar` Theme
///
///Conatain :
///- BackGround Color
///- Text color
///- Icon color
///- Text action color
///
///[InfoColors]
///
class InfoColors {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? actionColor;

  ///The colors of the widget
  ///
  ///if `null` all color will be copied from `Snackbar` Theme
  ///
  ///Conatain :
  ///- BackGround Color
  ///- Text color
  ///- Icon color
  ///- Text action color
  ///
  ///[InfoColors]
  ///
  const InfoColors({
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.actionColor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoColors &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor &&
          iconColor == other.iconColor &&
          actionColor == other.actionColor;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        backgroundColor,
        textColor,
        iconColor,
        actionColor,
      );
}

import 'package:flutter/material.dart';
import 'package:message_info/message_info.dart';
import 'package:message_info/src/util/message_position.dart';

class MessageInfoWidget extends StatefulWidget {
  final double padding;
  final int duration;
  final VoidCallback onDismissed;
  final double width;
  final MessagePosition position;
  final int ligneNbr;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? actionColor;
  const MessageInfoWidget({
    super.key,
    required this.onDismissed,
    required this.duration,
    required this.padding,
    required this.width,
    required this.position,
    required this.ligneNbr,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.actionColor,
  });

  @override
  State<MessageInfoWidget> createState() => _MessageInfoWidgetState();
}

class _MessageInfoWidgetState extends State<MessageInfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController? controllerEntring;
  late Animation<double> positionAnimation;
  late Animation<double> heightAnimation;
  late Animation<double> widthAnimation;
  late Animation<double> opacityAnimation;
  late bool _isDissmissed;
  double lineHeight = 22.0;
  @override
  void initState() {
    initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    controllerEntring?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isThemeDark = theme.brightness == Brightness.dark;
    final snackBarTheme = theme.snackBarTheme;
    final Color backGroundColor = getBackGround(
      isThemeDark,
      colorScheme,
      widget.backgroundColor,
      snackBarTheme,
    );
    final Color contentColor = getContentColor(
      isThemeDark,
      colorScheme,
      widget.textColor,
    );
    final TextStyle textStyle = getTextStyle(
      isThemeDark,
      colorScheme,
      widget.textColor,
      snackBarTheme,
      theme,
      contentColor,
    );
    return AnimatedBuilder(
      animation: controllerEntring!,
      builder: (context, child) => Positioned(
        top: widget.position == MessagePosition.top
            ? positionAnimation.value
            : null,
        bottom: widget.position == MessagePosition.bottom
            ? positionAnimation.value
            : null,
        left: MediaQuery.of(context).size.width / 2 - widthAnimation.value / 2,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            _isDissmissed = true;
            widget.onDismissed.call();
          },
          child: SizedBox(
            width: widget.width,
            height: heightAnimation.value,
            child: Stack(
              children: [
                Container(
                  width: widthAnimation.value,
                  height: widget.ligneNbr * 40,
                  decoration: BoxDecoration(
                    color: backGroundColor,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Opacity(
                    opacity: opacityAnimation.value,
                    //child: widget.child,
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          children: [
                            if (widget.icon != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Icon(
                                  widget.icon,
                                  color: widget.iconColor ?? contentColor,
                                  size: 20.0,
                                ),
                              ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  widget.text,
                                  style: textStyle,
                                  maxLines: (heightAnimation.value - 20) ~/ 16,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _dismiss() {
    if (mounted) {
      controllerEntring!.reverse();
    }
  }

  void initAnimation() {
    _isDissmissed = false;
    controllerEntring = AnimationController(
      duration: Duration(
        milliseconds: 250 + 50 * widget.ligneNbr + (widget.padding ~/ 30) * 50,
      ),
      vsync: this,
    );
    positionAnimation = Tween<double>(
      begin: -40,
      end: widget.padding,
    ).animate(
      CurvedAnimation(
        parent: controllerEntring!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    widthAnimation = Tween<double>(begin: 35.0, end: widget.width).animate(
      CurvedAnimation(
        parent: controllerEntring!,
        curve: const Interval(
          0.3,
          0.7,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    heightAnimation = Tween<double>(
      begin: 10 * 2 + lineHeight,
      end: 10 * 2 + widget.ligneNbr.toDouble() * lineHeight,
    ).animate(
      CurvedAnimation(
        parent: controllerEntring!,
        curve: const Interval(
          0.6,
          1,
          curve: Curves.easeInOutCubic,
        ),
      ),
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(Duration(seconds: widget.duration));
          if (mounted && !_isDissmissed) {
            _dismiss();
          }
        }

        if (status == AnimationStatus.dismissed) {
          if (mounted) {
            _isDissmissed = true;
            widget.onDismissed.call();
          }
        }
      });
    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controllerEntring!,
        curve: const Interval(
          0.4,
          1,
          curve: Curves.easeOut,
        ),
      ),
    );
    if (mounted) {
      controllerEntring!.forward();
    }
  }

  // //Get the default text Color
  // Color defaultTextColor(
  //     bool isThemeDark, ColorScheme colorScheme, Color? textColor) {
  //   if (textColor != null) return textColor;
  //   return isThemeDark
  //       ? colorScheme.surface
  //       : Color.alphaBlend(
  //           colorScheme.surface.withOpacity(0.80), colorScheme.surface);
  // }

//Get the default content color
  Color getContentColor(
    bool isThemeDark,
    ColorScheme colorScheme,
    Color? textColor,
  ) {
    return isThemeDark
        ? colorScheme.surface
        : Color.alphaBlend(
            colorScheme.surface.withOpacity(0.80), colorScheme.surface);
  }

  //Get the default text Color
  TextStyle getTextStyle(
    bool isThemeDark,
    ColorScheme colorScheme,
    Color? textColor,
    SnackBarThemeData snackBarTheme,
    ThemeData theme,
    Color contentColor,
  ) {
    var textStyle = snackBarTheme.contentTextStyle;
    textStyle ??= theme.textTheme.bodyMedium ?? const TextStyle();
    return textStyle.copyWith(color: contentColor);
  }

  //Get the default background
  Color getBackGround(
    bool isThemeDark,
    ColorScheme colorScheme,
    Color? background,
    SnackBarThemeData snackBarTheme,
  ) {
    if (background != null) return background;
    var snackBarBackground = snackBarTheme.backgroundColor;
    if (snackBarBackground != null) return snackBarBackground;
    return isThemeDark
        ? colorScheme.onSurface
        : Color.alphaBlend(
            colorScheme.onSurface.withOpacity(0.80), colorScheme.surface);
  }
}

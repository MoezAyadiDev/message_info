import 'package:flutter/material.dart';
import 'package:message_info/src/util/color_helper.dart';
import 'package:message_info/src/util/info_colors.dart';
import 'package:message_info/src/util/message_position.dart';

class InfoWidget extends StatefulWidget {
  /// the text will be displayed on message
  final String text;

  /// Prefix icon will be shown 20x20, can be null
  final IconData? icon;

  ///The padding from Top or Bottom default value 30.0
  final double padding;

  ///A callback to intercept dismiss function
  final VoidCallback onDismissed;

  ///The width of the widget
  final double width;

  ///The duration of shown the message
  final int duration;

  ///The poistion of the message
  ///
  ///can be Top or Bottom
  ///
  ///[MessagePosition]
  final MessagePosition position;

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
  final InfoColors? infoColors;
  final String? action;
  final Function? actionCallback;

  const InfoWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.padding,
    required this.onDismissed,
    required this.width,
    required this.duration,
    required this.position,
    required this.action,
    required this.actionCallback,
    this.infoColors,
  });

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController? _controllerEntring;
  late Animation<double> _positionAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _opacityAnimation;
  late bool _isDissmissed;
  double _finalHeight = 40;
  double _finalWidth = 400;
  late bool isHeightCheck;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _controllerEntring?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scaffoldWidth = MediaQuery.of(context).size.width;
    EdgeInsets textPadding =
        getTextPadding(widget.icon != null, widget.action != null);

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isThemeDark = theme.brightness == Brightness.dark;
    final snackBarTheme = theme.snackBarTheme;
    // final textButtonTheme = theme.textButtonTheme;
    final Color backGroundColor = getBackgroundColor(
      isThemeDark,
      colorScheme,
      widget.infoColors,
      snackBarTheme,
    );
    final Color contentColor = getContentColor(
      isThemeDark: isThemeDark,
      colorScheme: colorScheme,
    );
    final TextStyle textStyle = getTextStyle(
      snackBarTheme: snackBarTheme,
      theme: theme,
      contentColor: contentColor,
      infoColors: widget.infoColors,
    );
    final newTheme = theme.copyWith(
        brightness: isThemeDark ? Brightness.dark : Brightness.light);
    final Color textButtonColor = getTextButtonColor(
      isThemeDark,
      newTheme.colorScheme,
    );
    double newWidth = 35;
    return AnimatedBuilder(
      animation: _controllerEntring!,
      builder: (context, child) {
        newWidth = 35 + (_finalWidth - 35) * _widthAnimation.value;
        return Stack(
          children: [
            Positioned(
              top: widget.position == MessagePosition.top
                  ? _positionAnimation.value
                  : null,
              bottom: widget.position == MessagePosition.bottom
                  ? _positionAnimation.value
                  : null,
              left: scaffoldWidth / 2 - newWidth / 2,
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  _isDissmissed = true;
                  widget.onDismissed.call();
                },
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: newWidth,
                    height: 40 + (_finalHeight - 40) * _heightAnimation.value,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.icon != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 2.5),
                            child: Icon(
                              widget.icon,
                              color:
                                  getIconColor(widget.infoColors, contentColor),
                              size: _widthAnimation.value > 45 ? 40.0 : 30,
                            ),
                          ),
                        if (widget.icon == null) const SizedBox(width: 10.0),
                        // if (newWidth > _finalWidth - 5)
                        //   const SizedBox(width: 10.0),
                        //if (newWidth > 40)
                        buildTextWidget(textStyle, widget.action != null),
                        if (widget.action != null && newWidth > _finalWidth - 2)
                          SizedBox(
                            width: 80.0,
                            child: TextButton(
                              onPressed: () => widget.actionCallback!(),
                              child: Text(
                                widget.action!,
                                style: TextStyle(color: textButtonColor),
                              ),
                            ),
                          ),
                        if (widget.action == null && newWidth > _finalWidth - 2)
                          const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: textPadding,
                child: Opacity(
                  opacity: 0.0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(
                      widget.text,
                      key: _globalKey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _dismiss() {
    if (mounted) {
      _controllerEntring!.reverse();
    }
  }

  Widget buildTextWidget(TextStyle textStyle, bool hasAction) {
    return Flexible(
      fit: FlexFit.loose,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: hasAction
              ? const EdgeInsets.only(left: 10, top: 8, bottom: 8)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            widget.text,
            style: textStyle,
            overflow: TextOverflow.fade,
            softWrap: true,
            maxLines: 5,
          ),
        ),
      ),
    );
  }

  void initAnimation() {
    _isDissmissed = false;
    isHeightCheck = false;
    _controllerEntring = AnimationController(
      duration: const Duration(
        milliseconds: 400,
      ),
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: -40,
      end: widget.padding,
    ).animate(
      CurvedAnimation(
        parent: _controllerEntring!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    _widthAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controllerEntring!,
        curve: const Interval(
          0.3,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    // _widthAnimation = TweenSequence<double>(
    //   <TweenSequenceItem<double>>[
    //     TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 0, end: 1.1)
    //           .chain(CurveTween(curve: Curves.easeInOut)),
    //       weight: 1.0,
    //     ),
    //     TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 1.1, end: 0.95)
    //           .chain(CurveTween(curve: Curves.easeInOut)),
    //       weight: 2.0,
    //     ),
    //     TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 0.95, end: 1)
    //           .chain(CurveTween(curve: Curves.easeInOut)),
    //       weight: 2.0,
    //     ),
    //   ],
    // ).animate(_controllerEntring!);

    _heightAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controllerEntring!,
        curve: const Interval(
          0.7,
          1,
          curve: Curves.easeInOutCubic,
        ),
      ),
    )
      ..addStatusListener(
        (status) async {
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
        },
      )
      ..addListener(
        () {
          if (_controllerEntring!.lastElapsedDuration != null) {
            if (!isHeightCheck &&
                _controllerEntring!.lastElapsedDuration! >
                    _controllerEntring!.duration! * 0.28) {
              isHeightCheck = true;
              _finalHeight = _globalKey.currentContext!.size!.height + 20;
              _finalWidth = _globalKey.currentContext!.size!.width + 50;
              if (widget.icon != null) _finalWidth = _finalWidth + 20;
              if (widget.action != null) _finalWidth = _finalWidth + 60;
            }
          }
        },
      );
    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controllerEntring!,
        curve: Curves.linear,
      ),
    );
    if (mounted) {
      _controllerEntring!.forward();
    }
  }

  EdgeInsets getTextPadding(bool hasIcon, bool hasAction) {
    EdgeInsets textPadding =
        const EdgeInsets.symmetric(horizontal: 80, vertical: 10);
    if (hasIcon) {
      textPadding = textPadding.copyWith(left: textPadding.left + 65);
    }
    if (hasAction) {
      textPadding = textPadding.copyWith(right: 160.0);
    }

    return textPadding;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:message_info/src/util/message_position.dart';
import 'package:message_info/src/widgets/info_widget.dart';

OverlayEntry? _previousEntry;

class MessageInfo {
  MessageInfo.showMessage({
    required BuildContext context,
    required String text,
    IconData? icon,
    OverlayState? overlayState,
    MessagePosition position = MessagePosition.top,
    int maxLine = 1,
    double padding = 60.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    bool autoMaxLine = true,
    String? action,
    Function? actionCallback,
  }) {
    overlayState ??= Overlay.of(context);
    double width = MediaQuery.of(context).size.width - 40;
    // if (autoMaxLine) {
    //   debugPrint('${MediaQuery.of(context).devicePixelRatio}');
    //   double iconWidth = (icon == null) ? 0 : (10.0 + 15.0);
    //   double actionWidth = 0.0;
    //   double textWidgetWidth = width - iconWidth - actionWidth - 2 * 10.0;
    //   double lettreWidth = 6.75;
    //   debugPrint(
    //       'textwidth Calucled ${(text.length * lettreWidth)} textSapce = $textWidgetWidth');
    //   debugPrint('iconWidth $iconWidth');
    //   debugPrint('textWidgetWidth $textWidgetWidth');
    //   maxLine = max(((text.length * lettreWidth) / textWidgetWidth).ceil(), 1);
    //   debugPrint('$maxLine');
    // }
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return InfoWidget(
          onDismissed: () {
            if (overlayEntry.mounted && _previousEntry == overlayEntry) {
              overlayEntry.remove();
              _previousEntry = null;
            }
          },
          padding: padding,
          width: width,
          position: position,
          text: text,
          icon: icon,
          duration: duration,
          infoColors: null,
          action: action,
          actionCallback: actionCallback,
        );
        // return MessageInfoWidget(
        //   onDismissed: () {
        //     if (overlayEntry.mounted && _previousEntry == overlayEntry) {
        //       overlayEntry.remove();
        //       _previousEntry = null;
        //     }
        //   },
        //   padding: padding,
        //   width: width,
        //   position: position,
        //   ligneNbr: maxLine,
        //   text: text,
        //   icon: icon,
        //   duration: duration,
        // );
      },
    );
    if (_previousEntry != null && _previousEntry!.mounted) {
      _previousEntry?.remove();
    }
    overlayState.insert(overlayEntry);
    _previousEntry = overlayEntry;
  }
}

import 'package:flutter/material.dart';
import 'package:message_info/src/util/message_position.dart';

OverlayEntry? _previousEntry;

class MessageDisplay {
  MessageDisplay.showMessage({
    required BuildContext context,
    required String text,
    IconData? icon,
    OverlayState? overlayState,
    MessagePosition position = MessagePosition.top,
    int maxLine = 1,
    double padding = 30.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    bool autoMaxLine = true,
  }) {
    overlayState ??= Overlay.of(context);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Container(
              height: 20,
              color: Colors.red,
            ),
            Material(
              color: Colors.transparent,
              child: SizedBox(child: Text(text)),
            ),
          ],
        );
      },
    );
    if (_previousEntry != null && _previousEntry!.mounted) {
      _previousEntry?.remove();
    }
    overlayState.insert(overlayEntry);
    _previousEntry = overlayEntry;
  }
}

import 'package:flutter/material.dart';

class SwitcherWidget extends StatefulWidget {
  final Function(bool) callback;
  final String text;
  const SwitcherWidget({
    super.key,
    required this.callback,
    required this.text,
  });

  @override
  State<SwitcherWidget> createState() => _SwitcherWidgetState();
}

class _SwitcherWidgetState extends State<SwitcherWidget> {
  bool isTop = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.text),
        Switch(
          value: isTop,
          onChanged: (value) {
            _onChanged(value);
          },
        ),
      ],
    );
  }

  _onChanged(bool value) {
    setState(() {
      isTop = !isTop;
      widget.callback(value);
    });
  }
}

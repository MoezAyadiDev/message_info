import 'package:example/widgets/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:message_info/message_info.dart';

import 'color_scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isTop = true;
  bool lightTheme = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: lightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Message info example'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Test')),
                  SwitcherWidget(
                    text: 'Top info',
                    callback: (value) {
                      setState(() {
                        isTop = value;
                      });
                    },
                  ),
                  SwitcherWidget(
                    text: 'Light theme',
                    callback: (value) {
                      setState(() {
                        lightTheme = !lightTheme;
                      });
                    },
                  ),
                  ...displayInfo(context, isTop),
                  const Text(
                    '--------------- Info with action ---------------',
                  ),
                  const Text(
                    '--------------- Info with icon & action ---------------',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> displayInfo(BuildContext context, bool isTop) {
    return [
      const Text(
        '--------------- Info ---------------',
      ),
      ElevatedButton(
        onPressed: () {
          MessageInfo.showMessage(
            context: context,
            text: 'Info : Simple info message',
          );
        },
        child: const Text('Simple info'),
      ),
      ElevatedButton(
        onPressed: () {
          MessageInfo.showMessage(
            context: context,
            text:
                'Info : long info message the message is too long to be displayed on one line since autoLine is true on a a one line since autoLine is tru',
          );
        },
        child: const Text('Long info'),
      ),
      ElevatedButton(
        onPressed: () {
          MessageInfo.showMessage(
            context: context,
            text: 'Info : Simple info message',
            icon: Icons.error,
          );
        },
        child: const Text('Short info + icon'),
      ),
      ElevatedButton(
        onPressed: () {
          MessageInfo.showMessage(
            context: context,
            icon: Icons.error,
            position: isTop ? MessagePosition.top : MessagePosition.bottom,
            text:
                'Info : long info message the message is a too long to be displayed on one line since autoLine is true on a a one line since autoLine is tru',
          );
        },
        child: const Text('long with Icon'),
      ),
      ElevatedButton(
        onPressed: () {
          MessageInfo.showMessage(
            context: context,
            icon: Icons.error,
            position: isTop ? MessagePosition.top : MessagePosition.bottom,
            text:
                'Info : long info message the message is too long to be displayed on one line since autoLine is true on a a one line since autoLine is tru',
            actionCallback: () {
              print("Action clicked");
            },
            action: 'Click',
          );
        },
        child: const Text('Long info with action'),
      ),
      ElevatedButton(
        onPressed: () {
          MessageInfo.showMessage(
              context: context,
              icon: Icons.error,
              position: isTop ? MessagePosition.top : MessagePosition.bottom,
              text: 'Test un message info avec action',
              action: 'Annuler',
              actionCallback: () {
                print("Action clicked");
              });
        },
        child: const Text('Long info with icon and action'),
      ),
    ];
  }
}

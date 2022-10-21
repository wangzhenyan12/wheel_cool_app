import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheely_cool_app/screens/setup.dart';
import 'common/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Wheely Cool App',
      theme: appTheme,
      initialRoute: '/setup',
      routes: {
        '/setup': (context) => SetupScreen(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheely_cool_app/models/items.dart';
import 'package:wheely_cool_app/screens/setup.dart';
import 'package:wheely_cool_app/screens/wheel.dart';
import 'common/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemsModel(),
      child: MyApp(),
    ),
  );
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
        '/wheel': (context) => WheelScreen(),
      },
    );
  }
}

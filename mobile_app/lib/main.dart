import 'package:flutter/material.dart';
import 'package:mobile_app/home_page.dart';
import "vision.dart";
import 'package:mobile_app/main_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Raleway',
        ),
        home: MainScreen(),
      );
}

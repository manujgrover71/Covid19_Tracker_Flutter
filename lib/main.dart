import 'package:flutter/material.dart';
import 'package:Covid19_Tracker/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Gilroy'
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

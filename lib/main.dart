import 'package:flutter/material.dart';
import 'package:whatsappme2/Home/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s App Me2',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

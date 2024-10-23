import 'package:flutter/material.dart';
import 'services/HiveService.dart';
import 'screens/Welcome.dart';

void main() async {
  await HiveService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Welcome(),
    );
  }
}

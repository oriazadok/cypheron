import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'screens/auth/welcome.dart';
import 'screens/home/home.dart';
// import 'services/auth/auth_service.dart';
import 'models/user/user_model.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register the adapter for UserModel
  Hive.registerAdapter(UserModelAdapter());

  // Open the box where UserModel will be stored
  await Hive.openBox<UserModel>('userBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home()
      // home: _authService.getCurrentUser() != null ? Home() : Welcome(),
    );
  }
}

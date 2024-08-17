import 'package:flutter/material.dart';
import 'Scripts/login_signup_screen.dart'; // Import the login/signup screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login/Signup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginSignupScreen(),
    );
  }
}

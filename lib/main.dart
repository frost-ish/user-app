import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haven_admin/firebase_options.dart';
import 'login_screen.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(10, 10, 10, 1.000),
      ),
      home: LoginScreen(),
    );
  }
}

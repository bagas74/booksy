import 'screens/splash_screen.dart';
import 'package:flutter/material.dart' show BuildContext, MaterialApp, StatelessWidget, Widget, runApp;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Booksy', home: const SplashScreen());
  }
}

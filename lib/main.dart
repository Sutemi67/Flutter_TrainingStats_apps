import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/screens/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: MainScreen()));
  }
}

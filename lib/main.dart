import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/ui/screens/home_screen.dart';
import 'package:flutter_training_stats_apps/ui/screens/splash/splash_screen.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> _delayedStart() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: primaryColor),
      home: FutureBuilder(
        future: _delayedStart(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == .done) {
            return Scaffold(body: HomeScreen());
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}

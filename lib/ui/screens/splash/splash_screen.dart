import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello, champion!'),
        // child: FlutterLogo(size: 128),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/ui/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Запускаем навигацию сразу после создания виджета
    _delayedStart();
  }

  Future<void> _delayedStart() async {
    // Имитация загрузки
    await Future.delayed(const Duration(seconds: 1));

    // ПРОВЕРКА mounted:
    // Гарантирует, что мы не попытаемся перейти на другой экран,
    // если пользователь уже ушел со сплэша или виджет был удален из дерева.
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutesNames.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [FlutterLogo(size: 128), Text('Hello, champion!')],
        ),
      ),
    );
  }
}

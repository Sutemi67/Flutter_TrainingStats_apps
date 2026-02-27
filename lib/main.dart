import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/navigation.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_screen.dart';
import 'package:flutter_training_stats_apps/ui/screens/home/home_screen.dart';
import 'package:flutter_training_stats_apps/ui/screens/select/select_screen.dart';
import 'package:flutter_training_stats_apps/ui/screens/splash/splash_screen.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Гарантируем инициализацию биндинга перед асинхронными вызовами
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализируем данные локали для intl (опционально, но надёжно)
  await initializeDateFormatting('ru', null);
  final db = AppDatabase();

  runApp(MainApp(db: db));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.db});
  final AppDatabase db;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: primaryColor, brightness: .dark),
      routes: {
        AppRoutesNames.homeRoute: (context) => const HomeScreen(),
        AppRoutesNames.splashRoute: (context) => const SplashScreen(),
        AppRoutesNames.selectRoute: (context) => SelectScreen(db: db),
        AppRoutesNames.detailsRoute: (context) => DetailsScreen(
          exercise: ExerciseElement(name: '', reps: []),
        ),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutesNames.splashRoute,
      locale: const Locale('ru', 'RU'),
    );
  }
}

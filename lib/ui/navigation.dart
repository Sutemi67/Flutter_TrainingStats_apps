import 'package:flutter/cupertino.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_screen.dart';
import 'package:flutter_training_stats_apps/ui/screens/home/home_screen.dart';
import 'package:flutter_training_stats_apps/ui/screens/splash/splash_screen.dart';

abstract final class AppRoutesNames {
  static const homeRoute = "/home";
  static const splashRoute = "/splash";
  static const trainRoute = "/train";
}

final Map<String, WidgetBuilder> routesList = {
  AppRoutesNames.homeRoute: (context) => const HomeScreen(),
  AppRoutesNames.splashRoute: (context) => const SplashScreen(),
  AppRoutesNames.trainRoute: (context) => DetailsScreen(
    exercise: ExerciseElement(
      name: '',
      reps: RepsElement(weight: 2, reps: 2, day: DateTime.now()),
    ),
  ),
};

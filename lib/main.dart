import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/ui/navigation.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Гарантируем инициализацию биндинга перед асинхронными вызовами
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем данные локали для intl (опционально, но надёжно)
  await initializeDateFormatting('ru', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: primaryColor),
      routes: routesList,
      initialRoute: AppRoutesNames.splashRoute,
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('ru', 'RU'), // Русский
      //   Locale('en', 'US'), // Английский (опционально)
      // ],
      locale: const Locale('ru', 'RU'),
    );
  }
}

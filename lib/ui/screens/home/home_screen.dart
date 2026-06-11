import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/ui/navigation.dart';
import 'package:flutter_training_stats_apps/ui/screens/home/home_chart.dart';
import 'package:flutter_training_stats_apps/ui/screens/home/train_card.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase db;

  const HomeScreen({super.key, required this.db});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RepsElement> allReps = [];
  List<_TrainingDay> recentTrainings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sets = await widget.db.getAllSets();
    final reps = <RepsElement>[];
    for (final set in sets) {
      for (final exercise in set.exercises) {
        reps.addAll(exercise.reps);
      }
    }

    reps.sort((a, b) => b.day.compareTo(a.day));

    Map<DateTime, double> maxWeightByDate = {};
    for (final rep in reps) {
      final date = DateTime(rep.day.year, rep.day.month, rep.day.day);
      maxWeightByDate.update(
        date,
        (value) => value > rep.weight ? value : rep.weight,
        ifAbsent: () => rep.weight,
      );
    }

    final sortedDates = maxWeightByDate.keys.toList()..sort((a, b) => b.compareTo(a));
    final last5 = sortedDates.take(5).map((date) {
      return _TrainingDay(date: date, maxWeight: maxWeightByDate[date]!);
    }).toList();

    setState(() {
      allReps = reps;
      recentTrainings = last5;
      isLoading = false;
    });
  }

  void _navigateToSelect(BuildContext context) {
    Navigator.pushNamed(context, AppRoutesNames.selectRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Прогресс веса',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  WeightChart(allReps: allReps),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Последние тренировки',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...recentTrainings.map(
                    (t) => TrainCard(trainDate: t.date, weight: t.maxWeight),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _navigateToSelect(context),
        child: const Text('Тренировки'),
      ),
    );
  }
}

class _TrainingDay {
  final DateTime date;
  final double maxWeight;

  const _TrainingDay({required this.date, required this.maxWeight});
}

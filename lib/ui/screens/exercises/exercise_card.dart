import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_screen.dart';

class ExerciseCardElement extends StatelessWidget {
  const ExerciseCardElement({super.key, required this.exercise});
  final ExerciseElement exercise;
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DetailsScreen(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigateToDetails(context);
      },
      child: Card(
        elevation: 4,
        child: Padding(padding: EdgeInsets.all(8.0), child: Text('push-ups')),
      ),
    );
  }
}

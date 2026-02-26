import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';

class SetsCardElement extends StatelessWidget {
  const SetsCardElement({
    super.key,
    required this.exercises,
    required this.name,
  });
  final String name;
  final List<ExerciseElement> exercises;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(name),
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

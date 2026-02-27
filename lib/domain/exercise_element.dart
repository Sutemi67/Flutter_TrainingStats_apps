import 'package:flutter_training_stats_apps/domain/reps_element.dart';

final class ExerciseElement {
  final String name;
  final List<RepsElement> reps;

  ExerciseElement({required this.name, required this.reps});
  Map<String, dynamic> toMap(int setId) => {'name': name, 'set_id': setId};
}

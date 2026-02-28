import 'package:flutter_training_stats_apps/domain/exercise_element.dart';

final class SetElement {
  final int? id;
  final String name;
  final List<ExerciseElement> exercises;

  SetElement({this.id, required this.exercises, required this.name});

  Map<String, dynamic> toMap() => {'name': name};
}

import 'package:flutter_training_stats_apps/domain/reps_element.dart';

class ExerciseElement {
  final int? id;
  final String name;
  final List<RepsElement> reps;

  ExerciseElement({this.id, required this.name, required this.reps});

  // fromMap для чтения из БД
  factory ExerciseElement.fromMap(
    Map<String, dynamic> map, [
    List<RepsElement>? reps,
  ]) {
    return ExerciseElement(
      id: map['id'] as int?,
      name: map['name'] as String,
      reps: reps ?? [],
    );
  }

  //для записи в БД
  Map<String, dynamic> toMap() => {'name': name};
}

import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:sqflite/sqlite_api.dart';

Future<List<ExerciseElement>> getAllExercisesUsecase(Database db) async {
  final exercisesMaps = await db.query('exercises');
  final repsMaps = await db.query('reps');

  final Map<int, List<RepsElement>> repsByExercise = {};
  for (final repMap in repsMaps) {
    final exerciseId = repMap['exercise_id'] as int;
    repsByExercise
        .putIfAbsent(exerciseId, () => [])
        .add(
          RepsElement(
            id: repMap['id'] as int,
            weight: (repMap['weight'] as num).toDouble(),
            reps: repMap['reps'] as int,
            day: DateTime.parse(repMap['day'] as String),
          ),
        );
  }

  return exercisesMaps.map((exMap) {
    final exerciseId = exMap['id'] as int;
    return ExerciseElement(id: exerciseId, name: exMap['name'] as String, reps: repsByExercise[exerciseId] ?? []);
  }).toList();
}

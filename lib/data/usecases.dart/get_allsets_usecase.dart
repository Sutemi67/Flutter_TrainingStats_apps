import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:sqflite/sqflite.dart';

Future<List<SetElement>> getAllSetsUsecase(Database db) async {
  final setsMaps = await db.query('sets');
  final setExerciseMaps = await db.rawQuery('''
    SELECT 
      se.set_id,
      e.id as exercise_id,
      e.name as exercise_name
    FROM set_exercises se
    JOIN exercises e ON se.exercise_id = e.id
  ''');

  final Map<int, List<Map<String, dynamic>>> exercisesBySet = {};
  for (final item in setExerciseMaps) {
    final setId = item['set_id'] as int;
    exercisesBySet.putIfAbsent(setId, () => []).add({'id': item['exercise_id'], 'name': item['exercise_name']});
  }

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

  final List<SetElement> result = [];
  for (final setMap in setsMaps) {
    final setId = setMap['id'] as int;
    final setName = setMap['name'] as String;

    final exercisesForSet = exercisesBySet[setId] ?? [];
    final List<ExerciseElement> exercises = exercisesForSet.map((ex) {
      final exerciseId = ex['id'] as int;
      return ExerciseElement(id: exerciseId, name: ex['name'] as String, reps: repsByExercise[exerciseId] ?? []);
    }).toList();

    result.add(SetElement(id: setId, name: setName, exercises: exercises));
  }

  return result;
}

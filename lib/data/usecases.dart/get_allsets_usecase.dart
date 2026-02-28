import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:sqflite/sqflite.dart';

Future<List<SetElement>> getAllSetsUsecase(Database db) async {
  // 1. Получаем все сеты
  final setsMaps = await db.query('sets');

  // 2. Получаем связи set ↔ exercise через JOIN
  // Это вернёт: set_id, exercise_id, exercise_name
  final setExerciseMaps = await db.rawQuery('''
    SELECT 
      se.set_id,
      e.id as exercise_id,
      e.name as exercise_name
    FROM set_exercises se
    JOIN exercises e ON se.exercise_id = e.id
  ''');

  // 3. Группируем упражнения по set_id
  final Map<int, List<Map<String, dynamic>>> exercisesBySet = {};
  for (final item in setExerciseMaps) {
    final setId = item['set_id'] as int;
    exercisesBySet.putIfAbsent(setId, () => []).add({
      'id': item['exercise_id'],
      'name': item['exercise_name'],
    });
  }

  // 4. Получаем все повторения и группируем по exercise_id
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

  // 5. Собираем итоговую структуру
  final List<SetElement> result = [];
  for (final setMap in setsMaps) {
    final setId = setMap['id'] as int;
    final setName = setMap['name'] as String;

    final exercisesForSet = exercisesBySet[setId] ?? [];
    final List<ExerciseElement> exercises = exercisesForSet.map((ex) {
      final exerciseId = ex['id'] as int;
      return ExerciseElement(
        id: exerciseId,
        name: ex['name'] as String,
        reps: repsByExercise[exerciseId] ?? [],
      );
    }).toList();

    result.add(SetElement(id: setId, name: setName, exercises: exercises));
  }

  return result;
}

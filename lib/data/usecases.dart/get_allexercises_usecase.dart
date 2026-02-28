import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:sqflite/sqlite_api.dart';

Future<List<ExerciseElement>> getAllExercisesUsecase(Database db) async {
  // 1. Получаем все упражнения
  final exercisesMaps = await db.query('exercises');

  // 2. Получаем все повторения
  final repsMaps = await db.query('reps');

  // 3. Группируем повторения по exercise_id
  final Map<int, List<RepsElement>> repsByExercise = {};
  for (final repMap in repsMaps) {
    final exerciseId = repMap['exercise_id'] as int;
    repsByExercise
        .putIfAbsent(exerciseId, () => [])
        .add(
          RepsElement(
            id: repMap['id'] as int, // если нужен ID
            weight: (repMap['weight'] as num).toDouble(),
            reps: repMap['reps'] as int,
            day: DateTime.parse(repMap['day'] as String),
          ),
        );
  }

  // 4. Собираем результат
  return exercisesMaps.map((exMap) {
    final exerciseId = exMap['id'] as int;
    return ExerciseElement(
      id: exerciseId,
      name: exMap['name'] as String,
      reps: repsByExercise[exerciseId] ?? [],
    );
  }).toList();
}

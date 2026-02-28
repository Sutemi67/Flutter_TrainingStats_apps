import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:sqflite/sqlite_api.dart';

Future<int> insertExerciseUsecase(ExerciseElement exercise, Database db) async {
  return await db.insert('exercises', exercise.toMap());
}

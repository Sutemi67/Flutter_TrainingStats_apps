import 'package:sqflite/sqlite_api.dart';

Future<void> addExerciseToSetUsecase(
  Database db,
  int setId,
  int exerciseId,
) async {
  await db.insert('set_exercises', {
    'set_id': setId,
    'exercise_id': exerciseId,
  }, conflictAlgorithm: ConflictAlgorithm.ignore);
}

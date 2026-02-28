import 'package:sqflite/sqlite_api.dart';

Future<bool> removeExerciseFromSetUsecase(
  Database db,
  int setId,
  int exerciseId,
) async {
  final deleted = await db.delete(
    'set_exercises',
    where: 'set_id = ? AND exercise_id = ?',
    whereArgs: [setId, exerciseId],
  );
  return deleted > 0;
}

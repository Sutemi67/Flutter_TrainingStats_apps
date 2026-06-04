import 'package:sqflite/sqlite_api.dart';

Future<void> deleteExerciseUsecase(Database db, int exerciseId) async {
  await db.transaction((txn) async {
    await txn.delete('set_exercises', where: 'exercise_id = ?', whereArgs: [exerciseId]);

    await txn.delete('reps', where: 'exercise_id = ?', whereArgs: [exerciseId]);
    await txn.delete('exercises', where: 'id = ?', whereArgs: [exerciseId]);
  });
}

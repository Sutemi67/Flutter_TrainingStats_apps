import 'package:sqflite/sqlite_api.dart';

Future<void> deleteExerciseUsecase(Database db, int exerciseId) async {
  await db.transaction((txn) async {
    // 1. Удаляем связи с сетами (если CASCADE не сработает)
    await txn.delete(
      'set_exercises',
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
    );

    // 2. Удаляем все повторения (CASCADE должен сделать это, но явно надёжнее)
    await txn.delete('reps', where: 'exercise_id = ?', whereArgs: [exerciseId]);

    // 3. Удаляем само упражнение
    await txn.delete('exercises', where: 'id = ?', whereArgs: [exerciseId]);
  });
}

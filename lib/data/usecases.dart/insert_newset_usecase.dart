import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertSetUsecase(SetElement set, Database db) async {
  int setId = 0;

  await db.transaction((txn) async {
    // 1. Вставляем сет
    setId = await txn.insert('sets', {'name': set.name});

    // 2. Обрабатываем каждое упражнение
    for (var exercise in set.exercises) {
      int exerciseId;

      // 2a. Проверяем, существует ли упражнение с таким именем
      final existing = await txn.query(
        'exercises',
        columns: ['id'],
        where: 'name = ?',
        whereArgs: [exercise.name],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        // Используем существующее
        exerciseId = existing.first['id'] as int;
      } else {
        // Создаём новое
        exerciseId = await txn.insert('exercises', {'name': exercise.name});
      }

      // 2b. Создаём связь в junction-таблице
      await txn.insert('set_exercises', {
        'set_id': setId,
        'exercise_id': exerciseId,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      // 2c. Вставляем повторения для этого упражнения
      for (final repsElement in exercise.reps) {
        await txn.insert('reps', repsElement.toMap(exerciseId));
      }
    }
  });

  return setId;
}

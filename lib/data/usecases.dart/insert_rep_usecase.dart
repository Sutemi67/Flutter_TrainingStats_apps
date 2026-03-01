import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:sqflite/sqlite_api.dart';

/// Добавляет одну запись о повторениях к упражнению
/// Возвращает ID созданной записи в таблице reps
Future<int> insertRepsUsecase(
  Database db,
  int exerciseId,
  RepsElement reps,
) async {
  return await db.insert('reps', reps.toMap(exerciseId));
}

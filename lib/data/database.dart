import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'app_database.db',
      version: 2,
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
      onConfigure: (db) async {
        // Включаем поддержку внешних ключей
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Обработчик обновления схемы
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Удаляем старую таблицу users, если она существовала
      await db.execute('DROP TABLE IF EXISTS users');
      // Создаём новые таблицы (можно вызвать _onCreate, либо продублировать код)
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercises(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        set_id INTEGER NOT NULL,
        FOREIGN KEY (set_id) REFERENCES sets(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS reps(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        day TEXT NOT NULL,
        exercise_id INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
      )
    ''');
  }

  // Вставка полного сета (со всеми упражнениями и повторениями)
  Future<int> insertSet(SetElement set) async {
    Database db = await database;
    int setId = 0;

    await db.transaction((txn) async {
      // 1. Вставляем сет
      setId = await txn.insert('sets', set.toMap());

      // 2. Для каждого упражнения
      for (var exercise in set.exercises) {
        int exerciseId = await txn.insert('exercises', exercise.toMap(setId));

        // 3. Вставляем все повторения для упражнения
        for (final repsElement in exercise.reps) {
          await txn.insert('reps', repsElement.toMap(exerciseId));
        }
      }
    });

    return setId;
  }

  //Получить все сеты
  Future<List<SetElement>> getAllSets() async {
    final db = await database;

    // 1. Получаем все сеты
    final setsMaps = await db.query('sets');

    // 2. Получаем все упражнения
    final exercisesMaps = await db.query('exercises');

    // 3. Получаем все повторения
    final repsMaps = await db.query('reps');

    // Группируем упражнения по set_id
    final Map<int, List<Map<String, dynamic>>> exercisesBySet = {};
    for (final exMap in exercisesMaps) {
      final setId = exMap['set_id'] as int;
      exercisesBySet.putIfAbsent(setId, () => []).add(exMap);
    }

    // Группируем повторения по exercise_id
    final Map<int, List<RepsElement>> repsByExercise = {};
    for (final repMap in repsMaps) {
      final exerciseId = repMap['exercise_id'] as int;
      repsByExercise
          .putIfAbsent(exerciseId, () => [])
          .add(
            RepsElement(
              weight: (repMap['weight'] as num).toDouble(),
              reps: repMap['reps'] as int,
              day: DateTime.parse(repMap['day'] as String),
            ),
          );
    }

    // Строим результат
    final List<SetElement> result = [];
    for (final setMap in setsMaps) {
      final setId = setMap['id'] as int;
      final setName = setMap['name'] as String;

      final List<ExerciseElement> exercises = [];
      final exMapsForSet = exercisesBySet[setId] ?? [];

      for (final exMap in exMapsForSet) {
        final exerciseId = exMap['id'] as int;
        final exerciseName = exMap['name'] as String;
        final repsList = repsByExercise[exerciseId] ?? [];

        exercises.add(ExerciseElement(name: exerciseName, reps: repsList));
      }

      result.add(SetElement(name: setName, exercises: exercises));
    }

    return result;
  }
}

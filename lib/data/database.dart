import 'package:flutter_training_stats_apps/data/usecases.dart/add_exercise_to_set.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/delete_exercise_usecase.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/delete_set_usecase.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/get_allexercises_usecase.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/get_allsets_usecase.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/insert_newexercise_usecase.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/insert_newset_usecase.dart';
import 'package:flutter_training_stats_apps/data/usecases.dart/remove_exercise_from_set.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static const dbVersion = 4;
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
      version: dbVersion,
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
    if (oldVersion < newVersion) {
      // 1. Дропаем старые таблицы в правильном порядке (сначала те, на которые есть ссылки)
      await db.execute('DROP TABLE IF EXISTS reps');
      await db.execute('DROP TABLE IF EXISTS set_exercises');
      await db.execute('DROP TABLE IF EXISTS exercises');
      await db.execute('DROP TABLE IF EXISTS sets');

      // 2. Создаём новую схему
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Sets - независимая сущность
    await db.execute('''
    CREATE TABLE IF NOT EXISTS sets(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
  ''');

    // 2. Exercises - тоже независимая, без привязки к sets
    await db.execute('''
    CREATE TABLE IF NOT EXISTS exercises(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
  ''');

    // 3. связь многие-ко-многим между sets и exercises
    await db.execute('''
    CREATE TABLE IF NOT EXISTS set_exercises(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      set_id INTEGER NOT NULL,
      exercise_id INTEGER NOT NULL,
      FOREIGN KEY (set_id) REFERENCES sets(id) ON DELETE CASCADE,
      FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
      UNIQUE(set_id, exercise_id)
    )
  ''');

    // 4. Reps - привязаны к exercise
    await db.execute('''
    CREATE TABLE IF NOT EXISTS reps(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      weight REAL NOT NULL,
      reps INTEGER NOT NULL,
      day TEXT NOT NULL,
      exercise_id INTEGER NOT NULL,
      FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
    )
  ''');

    // 5. Опционально: индексы для ускорения частых запросов
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_reps_exercise ON reps(exercise_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_set_exercises_set ON set_exercises(set_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_set_exercises_exercise ON set_exercises(exercise_id)',
    );
  }

  // Вставка полного сета (со всеми упражнениями и повторениями)
  Future<int> insertSet(SetElement set) async {
    Database db = await database;
    return insertSetUsecase(set, db);
  }

  //Получить все сеты
  Future<List<SetElement>> getAllSets() async {
    final db = await database;
    return getAllSetsUsecase(db);
  }

  Future<void> deleteSet(int setId) async {
    final db = await database;
    deleteSetUsecase(setId, db);
  }

  Future<int> insertExercise(ExerciseElement exercise) async {
    final db = await database;
    return insertExerciseUsecase(exercise, db);
  }

  Future<void> deleteExercise(int exerciseId) async {
    final db = await database;
    deleteExerciseUsecase(db, exerciseId);
  }

  Future<List<ExerciseElement>> getAllExercises() async {
    return getAllExercisesUsecase(await database);
  }

  Future<void> addExerciseToSet(int setId, int exerciseId) async {
    addExerciseToSetUsecase(await database, setId, exerciseId);
  }

  Future<bool> removeExerciseFromSet(int setId, int exerciseId) async {
    return removeExerciseFromSetUsecase(await database, setId, exerciseId);
  }
}

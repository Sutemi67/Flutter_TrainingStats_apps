import 'package:sqflite/sqlite_api.dart';

Future<void> deleteSetUsecase(int setId, Database db) async {
  await db.transaction((txn) async {
    // 1. Удаляем связи с упражнениями (exercises сами НЕ удалятся!)
    await txn.delete('set_exercises', where: 'set_id = ?', whereArgs: [setId]);

    // 2. Удаляем сам сет
    await txn.delete('sets', where: 'id = ?', whereArgs: [setId]);
  });
}

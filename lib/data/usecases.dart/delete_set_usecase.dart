import 'package:sqflite/sqlite_api.dart';

Future<void> deleteSetUsecase(int setId, Database db) async {
  await db.transaction((txn) async {
    await txn.delete('set_exercises', where: 'set_id = ?', whereArgs: [setId]);
    await txn.delete('sets', where: 'id = ?', whereArgs: [setId]);
  });
}

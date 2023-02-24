import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:final_project/models/calorie_log_model.dart';

const String dbname = 'calorie_log.db';
const String tablename = 'history';

class CalorieLogProvider {
  late Database db;

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), dbname), version: 1,
        onCreate: (db, version) async {
      await db.execute('''
CREATE TABLE IF NOT EXISTS $tablename (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount INTEGER NOT NULL,
  time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)
  ''');
    });
  }

  Future<CalorieLog> insert(CalorieLog item) async {
    int id = await db.insert(tablename, item.toMap());
    return get(id);
  }

  Future<CalorieLog> get(int id) async {
    List<Map<String, dynamic>> extracted = await db.query(
      tablename,
      columns: ['id', 'amount', 'time'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return CalorieLog.fromMap(extracted.first);
  }

  Future<int> delete(int id) async {
    int rowsDeleted =
        await db.delete(tablename, where: 'id = ?', whereArgs: [id]);
    return rowsDeleted;
  }

  Future<List<CalorieLog>> getHistory() async {
    List<Map<String, dynamic>> data = await db.query(
      tablename,
      columns: ['id', 'amount', 'time'],
    );
    return data.map((e) => CalorieLog.fromMap(e)).toList();
  }

  Future<List<CalorieLog>> getDayHistory() async {
    List<Map<String, dynamic>> data = await db.query(
      tablename,
      columns: ['id', 'amount', 'time'],
    );
    final all = data.map((e) => CalorieLog.fromMap(e)).toList();
    final today = DateTime.now();
    return all.where((element) {
      final date = element.time!;
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();
  }

  Future close() async => db.close();
}

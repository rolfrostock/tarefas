import 'package:sqflite/sqflite.dart';
import 'package:tarefas/data/database.dart';
import 'package:tarefas/models/task_model.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE tasks('
      'id TEXT PRIMARY KEY,'
      'name TEXT,'
      'photo TEXT,'
      'difficulty INTEGER,'
      'startDate TEXT,'
      'endDate TEXT)';

  Future<void> save(TaskModel task) async {
    final db = await getDatabase();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(TaskModel task) async {
    final db = await getDatabase();
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<TaskModel>> findAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  Future<void> delete(String id) async {
    final db = await getDatabase();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

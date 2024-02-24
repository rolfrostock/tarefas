//lib/data/task_dao.dart:
import 'package:sqflite/sqflite.dart';
import 'package:tarefas/data/database.dart';
import 'package:tarefas/models/task_model.dart';

class TaskDao {
  // Ajuste a declaração SQL para incluir a coluna userId
  static const String tableSql = 'CREATE TABLE tasks('
      'id TEXT PRIMARY KEY,'
      'name TEXT,'
      'photo TEXT,'
      'difficulty INTEGER,'
      'startDate TEXT,'
      'endDate TEXT,'
      'userId TEXT)';

  // Salva ou atualiza uma tarefa no banco de dados
  Future<void> save(TaskModel task) async {
    final db = await getDatabase();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Atualiza uma tarefa existente
  Future<void> update(TaskModel task) async {
    final db = await getDatabase();
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Busca todas as tarefas
  Future<List<TaskModel>> findAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  // Busca tarefas atribuídas a um userId específico
  Future<List<TaskModel>> findTasksByUserId(String userId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  // Deleta uma tarefa pelo ID
  Future<void> delete(String id) async {
    final db = await getDatabase();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

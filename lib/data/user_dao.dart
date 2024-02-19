//lib/data/user_dao.dart

import 'package:sqflite/sqflite.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:tarefas/data/database.dart'; // Ajuste o caminho conforme sua estrutura de diretórios

class UserDao {
  // Nome da tabela de usuários no banco de dados
  static const String _tableName = 'users';

  // Método para salvar um novo usuário ou atualizar um existente
  Future<void> save(UserModel user) async {
    final db = await getDatabase(); // Obter instância do banco de dados
    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Substitui em caso de conflito de chave primária
    );
  }

  // Método para encontrar todos os usuários
  Future<List<UserModel>> findAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    return List.generate(result.length, (i) {
      return UserModel.fromMap(result[i]);
    });
  }

  // Método para deletar um usuário pelo id
  Future<void> delete(String id) async {
    final db = await getDatabase();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para atualizar um usuário
  Future<void> update(UserModel user) async {
    final db = await getDatabase();
    await db.update(
      _tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Método para encontrar um usuário pelo id
  Future<UserModel?> findById(String id) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }
}

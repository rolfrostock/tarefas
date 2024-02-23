//lib/data/user_dao.dart:
import 'package:sqflite/sqflite.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:tarefas/data/database.dart';

class UserDao {
static const String _tableName = 'users';

Future<void> save(UserModel user) async {
final db = await getDatabase();
await db.insert(
_tableName,
user.toMap(),
conflictAlgorithm: ConflictAlgorithm.replace,
);
}

Future<List<UserModel>> findAll() async {
final db = await getDatabase();
final List<Map<String, dynamic>> result = await db.query(_tableName);
return List.generate(result.length, (i) {
return UserModel.fromMap(result[i]);
});
}

Future<UserModel?> getUserByEmail(String email) async {
  // Logica para buscar o usuário no banco de dados pelo e-mail
  // Isso dependerá de como você está gerenciando o banco de dados
  final db = await getDatabase();
  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (maps.isNotEmpty) {
    return UserModel.fromMap(maps.first);
  }
  return null;
}


Future<void> delete(String id) async {
final db = await getDatabase();
await db.delete(
_tableName,
where: 'id = ?',
whereArgs: [id],
);
}

Future<void> update(UserModel user) async {
final db = await getDatabase();
await db.update(
_tableName,
user.toMap(),
where: 'id = ?',
whereArgs: [user.id],
);
}

Future<bool> authenticate(String email, String password) async {
  // Implementação de exemplo. Adapte conforme necessário.
  final db = await getDatabase();
  final List<Map<String, dynamic>> users = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );
  return users.isNotEmpty;
}

}


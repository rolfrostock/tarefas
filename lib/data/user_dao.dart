import 'package:sqflite/sqflite.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:tarefas/data/database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class UserDao {
  static const String _tableName = 'users';

  // Hash a password
  String hashPassword(String password) {
    final hash = sha256.convert(utf8.encode(password)).toString();
    print("Password hash generated: $hash"); // Print para controle
    return hash;
  }

  Future<void> save(UserModel user) async {
    final db = await getDatabase();
    try {
      var hashedPassword = hashPassword(user.password);
      var userMap = user.toMap();
      userMap['password'] = hashedPassword; // Update to hashed password
      await db.insert(_tableName, userMap, conflictAlgorithm: ConflictAlgorithm.replace);
      print("Usuário ${user.email} salvo no banco de dados com a senha hash: $hashedPassword");
    } catch (e) {
      print("Erro ao salvar usuário: $e");
    }
  }

  Future<List<UserModel>> findAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    print("Usuários encontrados: ${result.length}");
    return List.generate(result.length, (i) {
      return UserModel.fromMap(result[i]);
    });
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName, where: 'email = ?', whereArgs: [email]);
    print("Buscando usuário pelo e-mail: $email");
    if (maps.isNotEmpty) {
      print("Usuário encontrado: ${maps.first['email']}");
      return UserModel.fromMap(maps.first);
    } else {
      print("Nenhum usuário encontrado com o e-mail $email");
      return null;
    }
  }

  Future<void> delete(String id) async {
    final db = await getDatabase();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    print("Usuário com ID $id deletado.");
  }

  Future<void> update(UserModel user) async {
    final db = await getDatabase();
    var hashedPassword = hashPassword(user.password);
    var userMap = user.toMap();
    userMap['password'] = hashedPassword; // Update to hashed password
    await db.update(_tableName, userMap, where: 'id = ?', whereArgs: [user.id]);
    print("Usuário ${user.email} atualizado com nova senha hash: $hashedPassword");
  }

  Future<bool> authenticate(String email, String providedPassword) async {
    final db = await getDatabase();
    print("Tentativa de autenticação para o usuário: $email");
    final List<Map<String, dynamic>> users = await db.query(_tableName, where: 'email = ?', whereArgs: [email]);

    if (users.isNotEmpty) {
      var user = UserModel.fromMap(users.first);

      // Verifica se é o usuário administrador padrão pelo e-mail
      // E compara a senha como texto puro
      if (email == "admin@example.com" && user.password == providedPassword) {
        print("Usuário administrador padrão $email autenticado com sucesso.");
        return true;
      }
      // Para outros usuários, usa hash na senha para comparação
      else {
        var hashedProvidedPassword = hashPassword(providedPassword);
        if (user.password == hashedProvidedPassword) {
          print("Usuário $email autenticado com sucesso.");
          return true;
        } else {
          print("Falha na autenticação: senha incorreta para o usuário $email.");
        }
      }
    } else {
      print("Falha na autenticação: usuário $email não encontrado.");
    }
    return false;
  }



  Future<void> ensureDefaultUser() async {
    final db = await getDatabase();
    print("Verificando a existência do usuário administrador padrão...");
    var result = await db.query(_tableName, where: 'email = ?', whereArgs: ['admin@example.com']);
    if (result.isEmpty) {
      print("Criando usuário administrador padrão...");
      // Usuário administrador padrão criado com senha em texto puro
      await db.insert(_tableName, {
        'id': Uuid().v4(),
        'name': 'Admin Test',
        'email': 'admin@example.com',
        'password': 'password', // Senha em texto puro
        'role': 'admin',
      });
      print("Usuário administrador padrão criado com senha em texto puro.");
    } else {
      print("Usuário administrador padrão já existe.");
    }
  }

}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tarefas/data/task_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'app_database.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      // Criação da tabela de usuários
      db.execute(
        'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT)',
      );
      // Criação da tabela de tarefas com a coluna userId
      db.execute(
        'CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, photo TEXT, difficulty INTEGER, startDate TEXT, endDate TEXT, userId TEXT, FOREIGN KEY(userId) REFERENCES users(id))',
      );
    },
    version: 1, // Aumente a versão se estiver atualizando o esquema do banco de dados
    onUpgrade: (db, oldVersion, newVersion) {
      // Implemente a lógica de migração aqui se estiver atualizando a versão do banco de dados
    },
  );
}
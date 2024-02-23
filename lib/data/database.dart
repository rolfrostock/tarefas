//lib/data/database.dart:
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'app_database.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, role TEXT DEFAULT "colaborador", password TEXT DEFAULT "password")',
      );
      db.execute(
        'CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, photo TEXT, difficulty INTEGER, startDate TEXT, endDate TEXT, userId TEXT, FOREIGN KEY(userId) REFERENCES users(id))',
      );
    },
    version: 2, // Aumente a versão se estiver adicionando novas colunas
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        // Adiciona as colunas 'role' e 'password' com valores padrão para a tabela de usuários existente
        await db.execute('ALTER TABLE users ADD COLUMN role TEXT DEFAULT "colaborador"');
        await db.execute('ALTER TABLE users ADD COLUMN password TEXT DEFAULT "password"');
      }
    },
  );
}
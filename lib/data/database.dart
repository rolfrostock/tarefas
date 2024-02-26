//lib/data/database.dart:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart'; // Necessário para gerar IDs únicos

// Método para garantir a criação do usuário padrão no banco de dados
Future<void> ensureDefaultUser(Database db) async {
  const String defaultUserEmail = 'admin@example.com';
  List<Map> users = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [defaultUserEmail],
  );

  if (users.isEmpty) {
    await db.insert('users', {
      'id': Uuid().v4(), // Gera um ID único para o usuário
      'name': 'Admin Test',
      'email': defaultUserEmail,
      'role': 'admin',
      'password': 'password', // Considere usar um hash seguro em produção
    });
  }
}

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'app_database.db');
  return openDatabase(
    path,
    version: 2,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE users(
          id TEXT PRIMARY KEY, 
          name TEXT, 
          email TEXT, 
          role TEXT DEFAULT "colaborador", 
          password TEXT DEFAULT "password"
        );
      ''');

      await db.execute('''
        CREATE TABLE tasks(
          id TEXT PRIMARY KEY, 
          name TEXT, 
          photo TEXT, 
          difficulty INTEGER, 
          startDate TEXT, 
          endDate TEXT, 
          userId TEXT, 
          FOREIGN KEY(userId) REFERENCES users(id)
        );
      ''');

      // Após a criação das tabelas, garanta a criação do usuário padrão
      await ensureDefaultUser(db);
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) async {
      // Atualizações de esquema do banco de dados devem ser gerenciadas aqui
      if (oldVersion < 2) {
        // Exemplos de como adicionar colunas se necessário
        await db.execute('ALTER TABLE users ADD COLUMN role TEXT DEFAULT "colaborador";');
        await db.execute('ALTER TABLE users ADD COLUMN password TEXT DEFAULT "password";');
      }
    },
  );
}
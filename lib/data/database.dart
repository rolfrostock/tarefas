import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define the database version and table creation SQL statements as constants
const int _databaseVersion = 2;
const String _createUsersTableSQL = '''
  CREATE TABLE users(
    id TEXT PRIMARY KEY, 
    name TEXT, 
    email TEXT, 
    role TEXT DEFAULT "colaborador", 
    password TEXT DEFAULT "password"
  )
''';
const String _createTasksTableSQL = '''
  CREATE TABLE tasks(
    id TEXT PRIMARY KEY, 
    name TEXT, 
    photo TEXT, 
    difficulty INTEGER, 
    startDate TEXT, 
    endDate TEXT, 
    userId TEXT, 
    FOREIGN KEY(userId) REFERENCES users(id)
  )
''';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'app_database.db');
  return openDatabase(
    path,
    version: _databaseVersion,
    onCreate: (db, version) {
      // Execute table creation SQL statements
      db.execute(_createUsersTableSQL);
      db.execute(_createTasksTableSQL);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      // Handle schema upgrades by version
      if (oldVersion < 2) {
        // Add 'role' column to 'users' table, if it doesn't already exist
        await _addColumnIfNotExists(db, 'users', 'role', 'TEXT DEFAULT "colaborador"');
        // Add 'password' column to 'users' table, if it doesn't already exist
        await _addColumnIfNotExists(db, 'users', 'password', 'TEXT DEFAULT "password"');
      }
      // Handle future upgrades by adding more conditions here
    },
  );
}

// Utility function to add a column to a table if it does not exist
Future<void> _addColumnIfNotExists(Database db, String tableName, String columnName, String columnDefinition) async {
  // Correctly querying table info using PRAGMA
  final List<Map> columns = await db.rawQuery('PRAGMA table_info($tableName)');
  final columnExists = columns.any((Map column) => column['name'] == columnName);
  if (!columnExists) {
    await db.execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnDefinition');
  }
}

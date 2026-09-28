import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> abrirBanco() async {
    final String caminhoBanco = await getDatabasesPath();

    final String caminho = join(caminhoBanco, 'thebear.db');

    return openDatabase(caminho, version: 2, onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE usuarios(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          senha TEXT NOT NULL
        )
        ''');

      await db.execute('''
        CREATE TABLE pedidos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cliente_id INTEGER NOT NULL
          prato TEXT NOT NULL,
          quantidade INTEGER NOT NULL,
          valor_unitario REAL NOT NULL,
          status TEXT NOT NULL,
          FOREING KEY (cliente_id) REFERENCES usuarios (id)
        )
        ''');
    });
  }
}

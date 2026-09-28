import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> abrirBanco() async {
    final String caminhoBanco = await getDatabasesPath();

    final String caminho = join(caminhoBanco, "thebear.db");

    return openDatabase(
      caminho,
      version: 1,
      onConfigure: (db) {
        db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE usuarios(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          senha TEXT NOT NULL
        )
      ''');

        db.execute('''
        CREATE TABLE pedidos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cliente TEXT NOT NULL,
          prato TEXT NOT NULL,
          quantidade INTEGER NOT NULL,
          valor_unitario REAL NOT NULL,
          status TEXT NOT NULL,
          total REAL NOT NULL,
          classificacao TEXT NOT NULL
        )
      ''');
      },
    );
  }
}

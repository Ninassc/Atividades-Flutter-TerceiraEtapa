import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> abrirBanco() async {
    //descobre onde o dispositivo permite salvar banco de dados
    final String caminhoBanco = await getDatabasesPath();

    print("Local do banco: $caminhoBanco");

    //Junta a pasta encontrada com o nome do arquivo
    final String caminho = join(caminhoBanco, 'estoque.db');
    print('Banco completo $caminho');

    //Abre o banco de dados
    return openDatabase(
      caminho,

      //versão atual do banco
      version: 2,

      //Executa quando o banco é criado pela primeira vez
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE produtos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            categoria TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            preco REAL NOT NULL
          )
        ''');
      },
    );
  }
}

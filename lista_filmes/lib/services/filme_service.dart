import 'package:lista_filmes/models/filme.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FilmeService {
  Future<Database> abrirBanco() async {
    //descobre onde o dispositivo permite salvar banco de dados
    final String caminhoBanco = await getDatabasesPath();

    print("Local do banco: $caminhoBanco");

    //Junta a pasta encontrada com o nome do arquivo
    final String caminho = join(caminhoBanco, 'tarefas.db');
    print('Banco completo $caminho');

    //Abre o banco de dados
    return openDatabase(
      caminho,

      //versão atual do banco
      version: 1,

      //Executa quando o banco é criado pela primeira vez
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE filmes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            assistido INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> inserirFilme(Filme filme) async {
    final db = await abrirBanco();

    await db.insert('filmes',
        {'titulo': filme.titulo, 'assistido': filme.assistido ? 1 : 0});
  }

  Future<List<Filme>> listarFilmes() async {
    final db = await abrirBanco();

    final dados = await db.query('filmes');

    return dados.map((dado) {
      return Filme(
          id: dado['id'] as int,
          titulo: dado['titulo'] as String,
          assistido: dado['assistido'] == 1);
    }).toList();
  }

  Future<void> atualizarStatus(Filme filme) async {
    final db = await abrirBanco();

    await db.update('filmes', {'assistido': filme.assistido ? 1 : 0},
        where: 'id = ?', whereArgs: [filme.id]);
  }
}

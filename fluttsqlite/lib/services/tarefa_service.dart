import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/tarefa.dart';

class TarefaService {
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
          CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            concluida INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> inserirTarefas(Tarefa tarefa) async {
    final db = await abrirBanco();

    await db.insert('tarefas', {
      'titulo': tarefa.titulo,
      'concluida': tarefa.concluida ? 1 : 0,
    });
  }

  Future<List<Tarefa>> listarTarefas() async {
    //abre banco
    final db = await abrirBanco();

    //Equivale a SELECT * FROM tarefas
    final dados = await db.query('tarefas');

    return dados.map((item) {
      return Tarefa(
          id: item['id'] as int,
          titulo: item['titulo'] as String,
          concluida: item['concluida'] == 1);
    }).toList();
  }

  Future<void> atualizarStatus(Tarefa tarefa) async {
    final db = await abrirBanco();

    //atualiza um registro
    await db.update('tarefas', {'concluida': tarefa.concluida ? 1 : 0},
        where: 'id = ?', whereArgs: [tarefa.id]);
  }
}

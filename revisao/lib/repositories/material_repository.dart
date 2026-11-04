import '../models/material_evento.dart';
import '../services/database_service.dart';

// Somente esta classe consulta ou altera os registros da tabela materiais.
class MaterialRepository {
  final DatabaseService service;
  MaterialRepository(this.service);

  // A leitura já está pronta: o app abre mostrando os quatro materiais iniciais.
  Future<List<MaterialEvento>> listar() async {
    final db = await service.database;
    final linhas = await db.query('materiais', orderBy: 'nome COLLATE NOCASE');
    return linhas.map((linha) => MaterialEvento.fromMap(linha)).toList();
  }

  Future<bool> existeNome(String nome, {int? ignorarId}) async {
    // TODO 4: consulte o nome normalizado no banco.
    final resultado = await listar();
    for(var r in resultado){
      if(r.nome == nome){
        return true;
      }
    }
    // Quando ignorarId for informado, exclua esse ID da busca de duplicidade.
    return false;
  }

  Future<void> inserir(MaterialEvento material) async {
    // TODO 5: Insira material.toMap() na tabela materiais.
    final db = await service.database;
    final resultado = await db.insert('materiais', material.toMap());
  }

  Future<void> atualizar(MaterialEvento material) async {
    // TODO 6: Atualize somente o registro cujo ID está em material.id.
    final db = await service.database;

    await db.update(
        'materiais',
        {
          'nome': material.nome,
          'categoria': material.categoria,
          'quantidade': material.quantidade,
          'minimo': material.minimo
        },
        where: 'id = ?',
        whereArgs: [material.id]);
  }

  Future<void> excluir(int id) async {
    final db = await service.database;

    final resultado =
        await db.delete('materiais', where: 'id = ?', whereArgs: [id]);
  }
}

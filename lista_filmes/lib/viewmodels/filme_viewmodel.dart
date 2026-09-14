import 'package:flutter/foundation.dart';
import 'package:lista_filmes/models/filme.dart';
import 'package:lista_filmes/services/filme_service.dart';

class FilmeViewmodel extends ChangeNotifier {
  final FilmeService service = FilmeService();

  List<Filme> filmes = [];

  Future<void> carregarFilmes() async {
    filmes = await service.listarFilmes();
    notifyListeners();
  }

  Future<void> adicionarFilme(String titulo) async {
    if (titulo.isEmpty) {
      return;
    }

    final filme = Filme(titulo: titulo, assistido: false);

    await service.inserirFilme(filme);

    await carregarFilmes();
  }

  Future<void> alterarStatus(Filme filme) async {
    filme.assistido = !filme.assistido;

    await service.atualizarStatus(filme);

    await carregarFilmes();
  }
}

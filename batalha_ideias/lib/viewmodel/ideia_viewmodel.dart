import 'package:batalha_ideias/model/ideia.dart';
import 'package:batalha_ideias/services/ideia_service.dart';
import 'package:flutter/foundation.dart';

class IdeiaViewmodel extends ChangeNotifier {
  final _service = IdeiaService();

  List<Ideia> ideias = [];
  bool carregandoIdeias = false;

  IdeiaViewmodel() {
    carregarIdeias();
  }

  void carregarIdeias() {
    carregandoIdeias = true;
    notifyListeners();

    _service.listarIdeias().listen(
      (lista) {
        ideias = lista;
        carregandoIdeias = false;
        notifyListeners();
      },
      onError: (erro) {
        carregandoIdeias = false;
        notifyListeners();

        debugPrint('Erro ao carregar ideias: $erro');
      },
    );
  }

  Future<void> cadastrarIdeia(
    String titulo,
    String descricao,
    String autor,
  ) async {
    if (titulo.trim().isEmpty ||
        descricao.trim().isEmpty ||
        autor.trim().isEmpty) {
      return;
    }

    await _service.adicionarIdeia(
      titulo.trim(),
      descricao.trim(),
      autor.trim(),
      0,
    );

    carregarIdeias();
  }

  Future<void> votarIdeia(Ideia ideia) async {
    await _service.votarIdeia(ideia);
  }

  Future<void> excluirIdeia(String id) async {
    await _service.excluirIdeia(id);
    carregarIdeias();
  }

  Ideia? get ideiaMaisVotada {
    if (ideias.isEmpty) return null;

    return ideias.reduce(
      (atual, proxima) =>
          atual.quantidadeVotos >= proxima.quantidadeVotos ? atual : proxima,
    );
  }
}

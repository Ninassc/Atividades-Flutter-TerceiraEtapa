import 'package:batalha_ideias/model/ideia.dart';
import 'package:batalha_ideias/services/ideia_service.dart';
import 'package:flutter/foundation.dart';

class IdeiaViewmodel extends ChangeNotifier {
  final _service = IdeiaService();

  List<Ideia> ideias = [];
  bool carregandoIdeias = false;

  void carregarIdeias() {
    carregandoIdeias = false;
    notifyListeners();
    try {
      _service.listarIdeias().listen((lista) {
        ideias = lista;
      });
    } catch (e) {
      carregandoIdeias = false;
      notifyListeners();
    }
  }

  Future<void> cadastrarIdeia(String titulo ,String descricao, String autor) async {
    if (autor.trim().isEmpty || descricao.trim().isEmpty) {
      return;
    }

    int votos = 0;

    await _service.adicionarIdeia(titulo.trim() ,descricao.trim(), autor.trim(), votos);
    carregarIdeias();
  }

  Future<void> votarIdeia(Ideia ideia) async {
    await _service.votarIdeia(ideia);
    carregarIdeias();
  }

  Future<void> excluirIdeia(String id) async {
    await _service.excluirIdeia(id);
    carregarIdeias();
  }

  Ideia? get ideiaMaisVotada {
    if (ideias.isEmpty) return null;
    return ideias.reduce((atual, proxima) =>
        atual.quantidadeVotos >= proxima.quantidadeVotos ? atual : proxima);
  }
}

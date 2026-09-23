import 'package:central_missoes_firebase/models/missao.dart';
import 'package:central_missoes_firebase/services/missao_service.dart';
import 'package:flutter/material.dart';

class MissaoProvider extends ChangeNotifier {
  final _service = MissaoService();

  List<Missao> missoes = [];
  bool carregandoMissoes = false;

  void carregarTarefas() {
    carregandoMissoes = false;
    notifyListeners();
    try {
      _service.listarMissoes().listen((lista) {
        missoes = lista;
      });
    } catch (e) {
      carregandoMissoes = false;
      notifyListeners();
    }
  }

  Future<void> cadastrarMissao(String titulo, String dificuldade) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    int pontos = 0;

    if (dificuldade == "fácil") pontos = 10;
    if (dificuldade == 'médio') pontos = 20;
    if (dificuldade == 'difícil') pontos = 30;

    await _service.adicionarMissao(titulo.trim(), dificuldade.trim(), pontos);
  }

  Future<void> alterarStatus(Missao missao) async {
    await _service.concluirMissao(missao);
  }

  Future<void> excluirMissao(String id) async {
    await _service.excluirMissao(id);
  }
}

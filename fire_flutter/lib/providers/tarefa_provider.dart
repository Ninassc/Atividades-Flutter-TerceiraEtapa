import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/tarefa_service.dart';

class TarefaProvider extends ChangeNotifier {
  final TarefaService _service = TarefaService();

  List<Tarefa> tarefas = [];

  bool carregando = true;

  TarefaProvider() {
    carregarTarefas();
  }

  void carregarTarefas() {
    _service.listarTarefas().listen((lista) {
      tarefas = lista;

      carregando = false;

      notifyListeners();
    });
  }

  Future<void> adicionar(String titulo) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    await _service.adicionarTarefa(
      titulo.trim(),
    );
  }

  Future<void> alterarStatus(Tarefa tarefa) async {
    await _service.alterarStatus(tarefa);
  }

  Future<void> excluir(String id) async {
    await _service.excluirTarefa(id);
  }
}

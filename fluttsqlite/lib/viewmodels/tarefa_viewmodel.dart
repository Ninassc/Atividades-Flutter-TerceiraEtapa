import 'package:flutter/material.dart';
import 'package:fluttsqlite/services/tarefa_service.dart';

import '../models/tarefa.dart';

class TarefaViewModel extends ChangeNotifier {
  final TarefaService service = TarefaService();

  List<Tarefa> tarefas = [];

  Future<void> carregarTarefas() async {
    tarefas = await service.listarTarefas();

    notifyListeners();
  }

  Future<void> adicionarTarefa(String titulo) async {
    if (titulo.isEmpty) {
      return;
    }

    final tarefa = Tarefa(titulo: titulo, concluida: false);

    await service.inserirTarefas(tarefa);

    //após salvar busca novamente as tarefas
    await carregarTarefas();
  }

  Future<void> alterarStatus(Tarefa tarefa) async {
    tarefa.concluida = !tarefa.concluida;

    await service.atualizarStatus(tarefa);

    await carregarTarefas();
  }
}

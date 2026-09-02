import 'package:flutter/material.dart';

import '../services/voo_service.dart';

class VooProvider extends ChangeNotifier {
  List<dynamic> voos = [];
  bool carregando = false;
  bool carregandoDetalhes = false;

  Map<String, dynamic>? vooSelecionado;

  Future<void> carregarVoos() async {
    carregando = true;

    notifyListeners();

    voos = await VooService.buscarVoos();

    carregando = false;

    notifyListeners();
  }

  Future<void> carregarDetalhes(String identificacao) async {
    carregandoDetalhes = true;

    notifyListeners();

    vooSelecionado = await VooService.buscarDetalhesVoo(identificacao);

    carregandoDetalhes = false;

    notifyListeners();
  }
}

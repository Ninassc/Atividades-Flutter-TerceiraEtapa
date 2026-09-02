import 'package:flutter/material.dart';

import '../services/voo_service.dart';

class VooProvider extends ChangeNotifier {
  List<dynamic> voos = [];
  bool carregando = false;
  bool carregandoDetalhes = false;

  Map<String, dynamic>? vooSelecionado;

  Future<void> carregarVoos(String aeroporto, String tipo) async {
    carregando = true;

    notifyListeners();

    voos = await VooService.buscarVoos(aeroporto, tipo);

    carregando = false;

    notifyListeners();
  }

  Future<void> carregarDetalhes(
      String aeroporto, String tipo, String identificacao) async {
    carregandoDetalhes = true;

    notifyListeners();

    vooSelecionado =
        await VooService.buscarDetalhesVoo(aeroporto, tipo, identificacao);

    carregandoDetalhes = false;

    notifyListeners();
  }
}

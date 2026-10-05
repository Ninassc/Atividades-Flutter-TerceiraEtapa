import 'package:app_thebear/models/pedido.dart';
import 'package:app_thebear/services/pedido_service.dart';
import 'package:flutter/foundation.dart';

class PedidoViewmodel extends ChangeNotifier {
  final _service = PedidoService();

  List<Pedido> pedidos = [];
  bool carregandoPedidos = false;

  Future<void> carregarPedidos() async {
    carregandoPedidos = true;
    notifyListeners();

    try {
      pedidos = await _service.listarPedidos();
    } finally {
      carregandoPedidos = false;
      notifyListeners();
    }
  }

  Future<bool> cadastrarPedido(
    String cliente,
    String prato,
    int quantidade,
    double valorUnitario,
  ) async {
    final resultado = await _service.cadastrarPedido(
      Pedido(
        cliente: cliente,
        prato: prato,
        quantidade: quantidade,
        valorUnitario: valorUnitario,
      ),
    );

    if (resultado) {
      await carregarPedidos();
      return true;
    }

    return false;
  }

  Future<void> finalizarPedido(Pedido pedido) async {
    await _service.finalizarPedido(pedido);
    await carregarPedidos();
  }

  Future<bool> excluirPedido(Pedido pedido) async {
    final resultado = await _service.excluirPedido(pedido);

    if (resultado) {
      await carregarPedidos();
      return true;
    }

    return false;
  }
}

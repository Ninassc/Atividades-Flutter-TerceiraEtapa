import 'package:app_thebear/models/pedido.dart';
import 'package:app_thebear/services/database_service.dart';

class PedidoService {
  final _database = DatabaseService();

  Future<bool> cadastrarPedido(Pedido pedido) async {
    final db = await _database.abrirBanco();

    final resultado = await db.insert('pedidos', pedido.toMap());

    return resultado > 0;
  }

  Future<void> finalizarPedido(Pedido pedido) async {
    if (pedido.id == null) {
      throw ArgumentError('O pedido ainda não foi salvo no banco');
    }

    final db = await _database.abrirBanco();

    await db.update(
      'pedidos',
      {'status': 'finalizado'},
      where: 'id = ?',
      whereArgs: [pedido.id],
    );

    pedido.status = 'finalizado';
  }

  Future<bool> excluirPedido(Pedido pedido) async {
    final db = await _database.abrirBanco();

    final resultado = await db.delete(
      'pedidos',
      where: 'id = ?',
      whereArgs: [pedido.id],
    );

    return resultado > 0;
  }

  Future<List<Pedido>> listarPedidos() async {
    final db = await _database.abrirBanco();

    final pedidos = await db.query('pedidos');

    return pedidos.map((pedido) {
      return Pedido.fromJson(pedido);
    }).toList();
  }
}

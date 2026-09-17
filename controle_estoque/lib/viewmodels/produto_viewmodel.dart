import 'package:controle_estoque/models/produto.dart';
import 'package:controle_estoque/services/produto_service.dart';
import 'package:flutter/foundation.dart';

class ProdutoViewmodel extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> produtos = [];

  Future<void> carregarProdutos() async {
    produtos = await _service.listarProdutos();
    notifyListeners();
  }

  Future<bool> cadastrarProduto(
      String nome, String categoria, int quantidade, double preco) async {
    if (nome.isEmpty) {
      return false;
    }

    final resultado = await _service.cadastrarProduto(Produto(
        nome: nome,
        categoria: categoria,
        quantidade: quantidade,
        preco: preco));

    if (resultado) {
      carregarProdutos();

      return true;
    }

    return false;
  }

  Future<void> alterarQuantidade(Produto produto, int novaQuantidade) async {
    if (novaQuantidade < 0) return;

    produto.quantidade = novaQuantidade;

    await _service.alterarQuantidade(produto);

    await carregarProdutos();
  }

  Future<bool> deletarProduto(Produto produto) async {
    final resultado = await _service.deletarProduto(produto);

    if (resultado) {
      await carregarProdutos();
      return true;
    }

    return false;
  }

  Future<void> testarBancoNoTerminal() async {
    await _service.mostrarProdutosNoTerminal();
  }
}

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

  Future<void> cadastrarProduto(
      String nome, String categoria, int quantidade, double preco) async {
    if (nome.isEmpty) {
      return;
    }

    await _service.cadastrarProduto(Produto(
        nome: nome,
        categoria: categoria,
        quantidade: quantidade,
        preco: preco));

    carregarProdutos();
  }

  Future<void> alterarQuantidade(Produto produto, int novaQuantidade) async {
    if (novaQuantidade < 0) return;

    produto.quantidade = novaQuantidade;

    await _service.alterarQuantidade(produto);

    await carregarProdutos();
  }

  Future<void> deletarProduto(Produto produto) async {
    await _service.deletarProduto(produto);

    await carregarProdutos();
  }

  Future<void> testarBancoNoTerminal() async {
    await _service.mostrarProdutosNoTerminal();
  }
}

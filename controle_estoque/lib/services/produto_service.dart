import 'package:controle_estoque/models/produto.dart';
import 'package:controle_estoque/services/database_service.dart';

class ProdutoService {
  Future<bool> cadastrarProduto(Produto produto) async {
    final db = await DatabaseService().abrirBanco();

    final resultado = await db.insert('produtos', {
      'nome': produto.nome,
      'categoria': produto.categoria,
      'quantidade': produto.quantidade,
      'preco': produto.preco
    });

    return resultado > 0;
  }

  Future<List<Produto>> listarProdutos() async {
    final db = await DatabaseService().abrirBanco();

    final dados = await db.query('produtos');

    return dados.map((produto) {
      return Produto(
          id: produto['id'] as int,
          nome: produto['nome'] as String,
          categoria: produto['categoria'] as String,
          quantidade: produto['quantidade'] as int,
          preco: produto['preco'] as double);
    }).toList();
  }

  Future<void> alterarQuantidade(Produto produto) async {
    final db = await DatabaseService().abrirBanco();

    await db.update('produtos', {'quantidade': produto.quantidade},
        where: 'id = ?', whereArgs: [produto.id]);
  }

  Future<bool> deletarProduto(Produto produto) async {
    final db = await DatabaseService().abrirBanco();

    final resultado =
        await db.delete('produtos', where: 'id = ?', whereArgs: [produto.id]);

    return resultado > 0;
  }

  Future<void> mostrarProdutosNoTerminal() async {
    final db = await DatabaseService().abrirBanco();

    final produtos = await db.query('produtos');

    print('===== PRODUTOS NO BANCO =====');

    for (final produto in produtos) {
      print(produto);
    }
  }
}

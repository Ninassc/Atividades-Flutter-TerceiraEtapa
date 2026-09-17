import 'package:controle_estoque/models/produto.dart';
import 'package:controle_estoque/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque/widgets/botao_padrao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardProduto extends StatelessWidget {
  final Produto produto;

  const CardProduto({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    final produtoViewModel = Provider.of<ProdutoViewmodel>(context);

    return Card(
      child: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      produto.categoria,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Quantidade : ${produto.quantidade}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Preço : ${produto.preco}",
                      style: TextStyle(fontSize: 20),
                    ),
                    if (produto.quantidade <= 3)
                      Text(
                        "Estoque Baixo",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                  ],
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      final bool excluiu =
                          await produtoViewModel.deletarProduto(produto);

                      if (!context.mounted) return;
                      if (excluiu) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Produto excluído com sucesso!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Não foi possível excluir o produto.'),
                          ),
                        );
                      }
                    },
                    label: Icon(Icons.delete))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BotaoPadrao(
                    label: "Aumentar",
                    icone: Icons.add,
                    onPressed: () async {
                      await produtoViewModel.alterarQuantidade(
                          produto, produto.quantidade + 1);
                    }),
                BotaoPadrao(
                    label: "Diminuir",
                    icone: Icons.remove,
                    onPressed: () async {
                      if (produto.quantidade - 1 >= 0) {
                        await produtoViewModel.alterarQuantidade(
                            produto, produto.quantidade - 1);
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:controle_estoque/models/produto.dart';
import 'package:controle_estoque/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque/widgets/card_produto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<ProdutoViewmodel>(context, listen: false).carregarProdutos();
    Provider.of<ProdutoViewmodel>(context, listen: false).testarBancoNoTerminal();
    
  }

  @override
  Widget build(BuildContext context) {
    final produtoViewModel = Provider.of<ProdutoViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        var largura = constraints.maxWidth;

        return SafeArea(
            child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: produtoViewModel.produtos.length,
                      itemBuilder: (context, index) {
                        final Produto produto =
                            produtoViewModel.produtos[index];

                        return CardProduto(produto: produto);
                      }))
            ],
          ),
        ));
      }),
    );
  }
}

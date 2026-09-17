import 'package:controle_estoque/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque/widgets/botao_padrao.dart';
import 'package:controle_estoque/widgets/campo_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroProduto extends StatefulWidget {
  const CadastroProduto({super.key});

  @override
  State<CadastroProduto> createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  @override
  Widget build(BuildContext context) {
    final produtoViewmodel = Provider.of<ProdutoViewmodel>(context);

    TextEditingController controllerNomeProduto = TextEditingController();
    TextEditingController controllerCategoria = TextEditingController();
    TextEditingController controllerQuantidade = TextEditingController();
    TextEditingController controllerPreco = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Produto"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        var largura = constraints.maxWidth;

        return SafeArea(
            child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            spacing: 20,
            children: [
              CampoInput(
                  controller: controllerNomeProduto, label: "Nome do Produto"),
              CampoInput(controller: controllerCategoria, label: "Categoria"),
              CampoInput(controller: controllerQuantidade, label: "Quantidade"),
              CampoInput(controller: controllerPreco, label: "Preço"),
              SizedBox(
                width: largura * 0.5,
                child: BotaoPadrao(
                    label: "Cadastrar Produto",
                    icone: Icons.store,
                    onPressed: () async {
                      if (controllerNomeProduto.text.isNotEmpty &&
                          controllerQuantidade.text.isNotEmpty &&
                          controllerPreco.text.isNotEmpty) {
                        String nome = controllerNomeProduto.text;
                        String categoria = controllerCategoria.text;
                        int? quantidade =
                            int.tryParse(controllerQuantidade.text);
                        double? preco = double.tryParse(controllerPreco.text);

                        if (quantidade != null &&
                            preco != null &&
                            quantidade >= 0 &&
                            preco >= 0) {
                          bool cadastro =
                              await produtoViewmodel.cadastrarProduto(
                                  nome, categoria, quantidade, preco);

                          if (!context.mounted) return;

                          if (cadastro) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Cadastro realizado com sucesso!'),
                              ),
                            );
                          }
                        }
                      }
                    }),
              )
            ],
          ),
        ));
      }),
    );
  }
}

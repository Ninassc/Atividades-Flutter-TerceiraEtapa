import 'package:controle_estoque/pages/cadastro_produto.dart';
import 'package:controle_estoque/pages/estoque_page.dart';
import 'package:controle_estoque/pages/login_page.dart';
import 'package:controle_estoque/viewmodels/usuario_viewmodel.dart';
import 'package:controle_estoque/widgets/botao_padrao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = Provider.of<UsuarioViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Início"),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(builder: (context, constaints) {
        var largura = constaints.maxWidth;

        return SafeArea(
            child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "Olá, ${usuarioViewModel.usuarioLogado!.nome}!",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Controle de Estoque",
                style: TextStyle(fontSize: 28, color: Colors.deepOrange),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: largura * 0.5,
                  child: BotaoPadrao(
                      label: "Ver Produtos",
                      icone: Icons.inventory,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EstoquePage()));
                      })),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: largura * 0.5,
                child: BotaoPadrao(
                    label: "Cadastrar Produto",
                    icone: Icons.store,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroProduto()));
                    }),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  width: largura * 0.5,
                  child: BotaoPadrao(
                    label: "Sair",
                    icone: Icons.logout,
                    onPressed: () {
                      usuarioViewModel.usuarioLogado = null;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                  )),
            ],
          ),
        ));
      }),
    );
  }
}

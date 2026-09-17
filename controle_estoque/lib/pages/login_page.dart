import 'package:controle_estoque/pages/cadastro_page.dart';
import 'package:controle_estoque/pages/home_page.dart';
import 'package:controle_estoque/viewmodels/usuario_viewmodel.dart';
import 'package:controle_estoque/widgets/botao_padrao.dart';
import 'package:controle_estoque/widgets/campo_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerEmail = TextEditingController();
    TextEditingController controllerSenha = TextEditingController();
    
    final authViewModel = Provider.of<UsuarioViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        var largura = constraints.maxWidth;

        return SafeArea(
            child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: largura * 0.3,
                color: Colors.deepOrangeAccent,
              ),
              SizedBox(
                height: 20,
              ),
              CampoInput(controller: controllerEmail, label: "Email"),
              SizedBox(
                height: 20,
              ),
              CampoInput(controller: controllerSenha, label: "Senha"),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: largura * 0.5,
                child: BotaoPadrao(
                    label: 'Entrar',
                    icone: Icons.login,
                    onPressed: () async {
                      if (controllerEmail.text.isNotEmpty &&
                          controllerSenha.text.isNotEmpty) {
                        await authViewModel.buscarUsuario(
                            controllerEmail.text, controllerSenha.text);

                        if (!context.mounted) return;

                        if (authViewModel.usuarioLogado != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Email ou Senha Inválidos")));
                        }
                      }
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Ainda não possui conta?'),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: largura * 0.5,
                child: BotaoPadrao(
                    label: 'Cadastrar',
                    icone: Icons.person_add,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroPage()));
                    }),
              ),
            ],
          ),
        ));
      }),
    );
  }
}

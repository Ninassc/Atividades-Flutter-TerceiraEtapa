import 'package:controle_estoque/pages/login_page.dart';
import 'package:controle_estoque/viewmodels/usuario_viewmodel.dart';
import 'package:controle_estoque/widgets/botao_padrao.dart';
import 'package:controle_estoque/widgets/campo_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<CadastroPage> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<UsuarioViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
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
              CampoInput(controller: controllerNome, label: "Nome"),
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
                    label: 'Cadastrar',
                    icone: Icons.person_add,
                    onPressed: () async {
                      if (controllerNome.text.isNotEmpty &&
                          controllerEmail.text.isNotEmpty &&
                          controllerSenha.text.isNotEmpty) {
                        final cadastro = await authViewModel.cadastrarUsuario(
                            controllerNome.text,
                            controllerEmail.text,
                            controllerSenha.text);

                        if (!mounted) return;
                        if (cadastro) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cadastro realizado com sucesso!'),
                            ),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuário já cadastrado.'),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ],
          ),
        ));
      }),
    );
  }
}

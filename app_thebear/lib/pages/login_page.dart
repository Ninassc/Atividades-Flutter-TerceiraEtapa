import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_thebear/viewmodels/usuario_viewmodel.dart';
import 'cadastro_page.dart';
import 'pedidos_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final viewmodel = context.read<UsuarioViewmodel>();

      await viewmodel.buscarUsuario(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (!mounted) return;

      if (viewmodel.usuarioLogado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos.')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PedidosPage()),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível entrar.')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carregando = context.watch<UsuarioViewmodel>().carregandoBuscar;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (valor) =>
                        valor == null || !valor.contains('@')
                            ? 'Informe um e-mail válido'
                            : null,
                  ),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    validator: (valor) =>
                        valor == null || valor.isEmpty
                            ? 'Informe a senha'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: carregando ? null : _entrar,
                    child: Text(carregando ? 'Entrando...' : 'Entrar'),
                  ),
                  TextButton(
                    onPressed: carregando
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CadastroPage(),
                              ),
                            ),
                    child: const Text('Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_thebear/viewmodels/usuario_viewmodel.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final viewmodel = context.read<UsuarioViewmodel>();
      final email = _emailController.text.trim();

      if (await viewmodel.buscarPorEmail(email)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este e-mail já está cadastrado.')),
        );
        return;
      }

      final cadastrou = await viewmodel.cadastrarUsuario(
        _nomeController.text.trim(),
        email,
        _senhaController.text,
      );

      if (!mounted) return;

      if (cadastrou) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada! Faça o login.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível criar a conta.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar usuário.')),
      );
    } 
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = context.watch<UsuarioViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
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
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome completo'),
                    validator: (valor) =>
                        valor == null || valor.trim().isEmpty
                            ? 'Informe seu nome'
                            : null,
                  ),
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
                            ? 'Informe uma senha'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: usuarioViewModel.salvando ? null : _cadastrar,
                    child: Text(usuarioViewModel.salvando ? 'Salvando...' : 'Cadastrar'),
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
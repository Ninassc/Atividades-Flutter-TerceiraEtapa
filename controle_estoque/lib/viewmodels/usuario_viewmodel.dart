import 'package:controle_estoque/models/usuario.dart';
import 'package:controle_estoque/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class UsuarioViewmodel extends ChangeNotifier {
  final AuthService _service = AuthService();

  late Usuario usuarioLogado;

  bool carregarBuscar = false;

  Future<void> cadastrarUsuario(String nome, String email, String senha) async {
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      return;
    }

    final usuario = Usuario(nome: nome, email: email, senha: senha);

    await _service.cadastrar(usuario);

    notifyListeners();
  }

  Future<void> buscarUsuario(String email, String senha) async {
    carregarBuscar = true;
    notifyListeners();

    final usuario = await _service.buscarUsuario(email, senha);

    if (usuario != null) {
      usuarioLogado = usuario;
    }

    carregarBuscar = false;
    notifyListeners();
  }
}

import 'package:controle_estoque/models/usuario.dart';
import 'package:controle_estoque/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class UsuarioViewmodel extends ChangeNotifier {
  final AuthService _service = AuthService();

  Usuario? usuarioLogado;

  bool carregarBuscar = false;

  Future<void> carregarUsuarios() async {
    await _service.listarUsuarios();
    notifyListeners();
  }

  Future<bool> cadastrarUsuario(String nome, String email, String senha) async {
    final existe = await buscarPorEmail(email);

    if (existe == false) {
      final usuario = Usuario(nome: nome, email: email, senha: senha);

      await _service.cadastrar(usuario);

      carregarUsuarios();

      return true;
    }

    return false;
  }

  //para verificar se as credencias batem (para login)
  Future<void> buscarUsuario(String email, String senha) async {
    carregarBuscar = true;
    notifyListeners();

    usuarioLogado = await _service.buscarUsuario(email, senha);

    carregarBuscar = false;
    notifyListeners();
  }


  //para verificar se o usuário com esse email existe (usado para validar se o cadastro pode acontecer)
  Future<bool> buscarPorEmail(String email) async {
    carregarBuscar = true;
    notifyListeners();

    final usuario = await _service.buscarPorEmail(email);

    carregarBuscar = false;
    notifyListeners();

    if (usuario != null) {
      return true;
    }

    return false;
  }
}

import 'package:app_thebear/models/usuario.dart';
import 'package:app_thebear/services/usuario_service.dart';
import 'package:flutter/foundation.dart';

class UsuarioViewmodel extends ChangeNotifier {
  final _service = UsuarioService();

  List<Usuario> usuarios = [];

  Usuario? usuarioLogado;

  bool carregandoUsuarios = false;
  bool carregandoBuscar = false;

  Future<void> carregarUsuarios() async {
    carregandoUsuarios = true;
    notifyListeners();

    try {
      usuarios = await _service.listarUsuarios();
    } finally {
      carregandoUsuarios = false;
      notifyListeners();
    }
  }

  Future<bool> cadastrarUsuario(String nome, String email, String senha) async {
    final resultado = await _service.cadastrarUsuario(
      Usuario(nome: nome, email: email, senha: senha),
    );

    if (resultado) {
      await carregarUsuarios();
      return true;
    }

    return false;
  }

  //para verificar se as credencias batem (para login)
  Future<void> buscarUsuario(String email, String senha) async {
    carregandoBuscar = true;
    notifyListeners();

    try {
      usuarioLogado = await _service.buscarUsuario(email, senha);
    } finally {
      carregandoBuscar = false;
      notifyListeners();
    }
  }

  Future<bool> buscarPorEmail(String email) async {
    carregandoBuscar = true;
    notifyListeners();

    final usuario = await _service.buscarPorEmail(email);
    carregandoBuscar = false;
    notifyListeners();

    if (usuario != null) {
      return true;
    }

    return false;
  }
}

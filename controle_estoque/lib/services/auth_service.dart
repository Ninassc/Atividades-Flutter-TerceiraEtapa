import 'package:controle_estoque/models/usuario.dart';
import './database_service.dart';

class AuthService {
  Future<void> cadastrar(Usuario usuario) async {
    final db = await DatabaseService().abrirBanco();

    await db.insert('usuarios',
        {'nome': usuario.nome, 'email': usuario.email, 'senha': usuario.senha});
  }

  Future<Usuario?> buscarUsuario(String email, String senha) async {
    final db = await DatabaseService().abrirBanco();

    final resultado = await db.query('usuarios',
        where: 'email = ? AND senha = ?', whereArgs: [email, senha]);

    if (resultado.isNotEmpty) {
      final dadosUsuario = resultado.first;

      return Usuario(
        nome: dadosUsuario['nome'] as String,
        email: dadosUsuario['email'] as String,
        senha: dadosUsuario['senha'] as String,
      );
    }

    return null;
  }

  Future<Usuario?> buscarPorEmail(String email) async {
    final db = await DatabaseService().abrirBanco();

    final resultado =
        await db.query('usuarios', where: 'email = ?', whereArgs: [email]);

    if (resultado.isNotEmpty) {
      final dadosUsuario = resultado.first;

      return Usuario(
        nome: dadosUsuario['nome'] as String,
        email: dadosUsuario['email'] as String,
        senha: dadosUsuario['senha'] as String,
      );
    }

    return null;
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await DatabaseService().abrirBanco();

    final usuarios = await db.query('usuarios');

    return usuarios.map((usuario) {
      return Usuario(
          nome: usuario['nome'] as String,
          email: usuario['email'] as String,
          senha: usuario['senha'] as String);
    }).toList();
  }
}

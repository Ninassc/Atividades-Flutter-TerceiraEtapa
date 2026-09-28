import 'package:app_thebear/models/usuario.dart';
import 'package:app_thebear/services/database_service.dart';

class UsuarioService {
  final _database = DatabaseService();

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final db = await _database.abrirBanco();
    final resultado = await db.insert("usuarios", usuario.toJson());

    return resultado > 0;
  }

  Future<Usuario?> buscarUsuario(String email, String senha) async {
    final db = await _database.abrirBanco();

    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isNotEmpty) {
      final dadosUsuario = resultado.first;

      return Usuario.fromJson(dadosUsuario);
    }

    return null;
  }

  Future<Usuario?> buscarPorEmail(String email) async {
    final db = await _database.abrirBanco();

    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (resultado.isNotEmpty) {
      final dadosUsuario = resultado.first;

      return Usuario.fromJson(dadosUsuario);
    }

    return null;
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await _database.abrirBanco();

    final usuarios = await db.query('usuarios');

    return usuarios.map((usuario) {
      return Usuario.fromJson(usuario);
    }).toList();
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

class VooService {
  static const String url = 'http://127.0.0.1:5001/api/voos';

  static Future<List<dynamic>> buscarVoos() async {
    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> dadosDecodificados = jsonDecode(resposta.body);

      final List<dynamic> listaDeVoos = dadosDecodificados['voos'];

      return listaDeVoos;
    }
    throw Exception(
      'Erro ao buscar voos',
    );
  }

  static Future<Map<String, dynamic>> buscarDetalhesVoo(
      String identificacao) async {
    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode == 200) {
      final res = jsonDecode(resposta.body);

      for (var r in res) {
        if (r["identificao"] == identificacao) {
          return r;
        }
      }
    }

    throw Exception(
      'Erro ao buscar detalhes do voo',
    );
  }
}

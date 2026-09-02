import 'dart:convert';

import 'package:http/http.dart' as http;

class VooService {
  static const String url = 'http://127.0.0.1:5001/api/voos';

  static Future<List<dynamic>> buscarVoos(String aeroporto, String tipo) async {
    final resposta =
        await http.get(Uri.parse('$url?aeroporto=$aeroporto&tipo=$tipo'));

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
      String aeroporto, String tipo, String identificacao) async {
    final resposta =
        await http.get(Uri.parse('$url?aeroporto=$aeroporto&tipo=$tipo'));

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> dadosDecodificados = jsonDecode(resposta.body);

      final List<dynamic> listaDeVoos = dadosDecodificados['voos'];

      for (var r in listaDeVoos) {
        if (r["identificacao"] == identificacao) {
          return r;
        }
      }
    }

    throw Exception(
      'Erro ao buscar detalhes do voo',
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Comentario {
  String id;
  String texto;
  String nomeUsuario;
  String idPublicacao;
  DateTime criadoEm;

  Comentario({
    required this.id,
    required this.texto,
    required this.nomeUsuario,
    required this.idPublicacao,
    required this.criadoEm,
  });

  factory Comentario.fromMap(String id, Map<String, dynamic> dados) {
    return Comentario(
      id: id,
      texto: dados['texto'] ?? '',
      nomeUsuario: dados['nome_usuario'] ?? 'Anônimo',
      idPublicacao: dados['id_publicacao'] ?? '',
      criadoEm: dados['criado_em'] != null
          ? (dados['criado_em'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'nome_usuario': nomeUsuario,
      'id_publicacao': idPublicacao,
      'criado_em': Timestamp.fromDate(criadoEm),
    };
  }
}
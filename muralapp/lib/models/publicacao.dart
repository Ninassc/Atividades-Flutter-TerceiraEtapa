import 'package:cloud_firestore/cloud_firestore.dart';

class Publicacao {
  String id;
  String autorNome;
  String texto;
  DateTime? criadoEm;

  Publicacao({
    required this.id,
    required this.autorNome,
    required this.texto,
    this.criadoEm,
  });

  factory Publicacao.fromMap(String id, Map<String, dynamic> dados) {
    return Publicacao(
      id: id,
      autorNome: dados['autorNome'] ?? 'Usuário',
      texto: dados['texto'] ?? '',
      criadoEm: dados['criadoEm'] != null
          ? (dados['criadoEm'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'autorNome': autorNome,
      'texto': texto,
      'criadoEm': criadoEm,
    };
  }
}

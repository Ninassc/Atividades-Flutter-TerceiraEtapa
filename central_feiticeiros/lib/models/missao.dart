class Missao {
  String id;
  String titulo;
  String grau;
  bool concluida;
  String usuarioId;

  Missao(
      {required this.id,
      required this.titulo,
      required this.grau,
      required this.concluida,
      required this.usuarioId});

  factory Missao.fromMap(String id, Map<String, dynamic> dados) {
    return Missao(
        id: id,
        titulo: dados['titulo'],
        grau: dados['grau'],
        concluida: dados['concluida'],
        usuarioId: dados['usuarioId']);
  }
}

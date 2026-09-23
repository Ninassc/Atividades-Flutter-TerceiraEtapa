class Missao {
  String id;
  String titulo;
  String dificuldade;
  int pontos;
  bool concluida;

  Missao(
      {required this.id,
      required this.titulo,
      required this.dificuldade,
      required this.pontos,
      required this.concluida});

  factory Missao.fromMap(String id, Map<String, dynamic> dados) {
    return Missao(
        id: id,
        titulo: dados['titulo'],
        dificuldade: dados['dificuldade'],
        pontos: dados['pontos'],
        concluida: dados['concluida']);
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'dificuldade': dificuldade,
      'pontos': pontos,
      'concluida': concluida
    };
  }
}

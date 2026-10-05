class Ideia {
  String id;
  String titulo;
  String descricao;
  String autor;
  int quantidadeVotos;

  Ideia(
      {required this.id,
      required this.titulo,
      required this.descricao,
      required this.autor,
      required this.quantidadeVotos});

  factory Ideia.fromMap(String id, Map<String, dynamic> dados) {
    return Ideia(
        id: id,
        titulo: dados['titulo'],
        descricao: dados['descricao'],
        autor: dados['autor'],
        quantidadeVotos: dados['quantidade_votos']);
  }
}

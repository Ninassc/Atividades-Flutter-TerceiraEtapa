class Tarefa {
  String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.concluida,
  });

  factory Tarefa.fromMap(String id, Map<String, dynamic> dados) {
    return Tarefa(
      id: id,
      titulo: dados['titulo'] ?? '',
      concluida: dados['concluida'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'concluida': concluida,
    };
  }
}

class Pedido {
  int? id;
  String cliente;
  String prato;
  int quantidade;
  double valorUnitario;
  String status;

  Pedido({
    this.id,
    required this.cliente,
    required this.prato,
    required this.quantidade,
    required this.valorUnitario,
    this.status = "pendente",
  });

  double get total => quantidade * valorUnitario;
  String get classificacao =>
      quantidade < 5 ? "Pedido Normal" : "Pedido Grande";

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as int,
      cliente: json['cliente'] as String,
      prato: json['prato'] as String,
      quantidade: json['quantidade'] as int,
      valorUnitario: json['valor_unitario'] as double,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cliente': cliente,
      'prato': prato,
      'quantidade': quantidade,
      'valor_unitario': valorUnitario,
      'status': status,
      'total': total,
      'classificacao': classificacao,
    };
  }
}

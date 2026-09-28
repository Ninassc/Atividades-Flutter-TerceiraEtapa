class Pedido {
  int? id;
  int clienteId;
  String prato;
  int quantidade;
  double valorUnitario;
  String status;

  Pedido(
      {this.id,
      required this.clienteId,
      required this.prato,
      required this.quantidade,
      required this.valorUnitario,
      this.status = "pendente"});
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_thebear/models/pedido.dart';
import 'package:app_thebear/viewmodels/pedido_viewmodel.dart';
import 'package:app_thebear/viewmodels/usuario_viewmodel.dart';
import 'login_page.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PedidoViewmodel>().carregarPedidos();
      }
    });
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _finalizar(Pedido pedido) async {
    try {
      await context.read<PedidoViewmodel>().finalizarPedido(pedido);
      if (mounted) _mensagem('Pedido finalizado.');
    } catch (_) {
      if (mounted) _mensagem('Não foi possível finalizar o pedido.');
    }
  }

  Future<void> _excluir(Pedido pedido) async {
    try {
      final excluiu =
          await context.read<PedidoViewmodel>().excluirPedido(pedido);

      if (!mounted) return;
      _mensagem(excluiu ? 'Pedido excluído.' : 'Não foi possível excluir.');
    } catch (_) {
      if (mounted) _mensagem('Não foi possível excluir o pedido.');
    }
  }

  Future<void> _abrirCadastro() async {
    final formKey = GlobalKey<FormState>();
    final clienteController = TextEditingController();
    final pratoController = TextEditingController();
    final quantidadeController = TextEditingController();
    final valorController = TextEditingController();

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Novo pedido'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: clienteController,
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      validator: (valor) =>
                          valor == null || valor.trim().isEmpty
                              ? 'Informe o cliente'
                              : null,
                    ),
                    TextFormField(
                      controller: pratoController,
                      decoration: const InputDecoration(labelText: 'Prato'),
                      validator: (valor) =>
                          valor == null || valor.trim().isEmpty
                              ? 'Informe o prato'
                              : null,
                    ),
                    TextFormField(
                      controller: quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Quantidade'),
                      validator: (valor) {
                        final quantidade = int.tryParse(valor ?? '');
                        return quantidade == null || quantidade < 1
                            ? 'Informe uma quantidade maior que zero'
                            : null;
                      },
                    ),
                    TextFormField(
                      controller: valorController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Valor unitário',
                        prefixText: 'R\$ ',
                      ),
                      validator: (valor) {
                        final numero = double.tryParse(
                          (valor ?? '').replaceAll(',', '.'),
                        );
                        return numero == null || numero <= 0
                            ? 'Informe um valor maior que zero'
                            : null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  final cadastrou = await context
                      .read<PedidoViewmodel>()
                      .cadastrarPedido(
                        clienteController.text.trim(),
                        pratoController.text.trim(),
                        int.parse(quantidadeController.text),
                        double.parse(
                          valorController.text.replaceAll(',', '.'),
                        ),
                      );

                  if (!dialogContext.mounted) return;

                  if (cadastrou) {
                    Navigator.pop(dialogContext);
                    if (mounted) _mensagem('Pedido cadastrado.');
                  } else if (mounted) {
                    _mensagem('Não foi possível cadastrar o pedido.');
                  }
                } catch (_) {
                  if (mounted) _mensagem('Erro ao cadastrar o pedido.');
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      );
    } finally {
      // Aguarda o diálogo encerrar antes de liberar os controllers.
      clienteController.dispose();
      pratoController.dispose();
      quantidadeController.dispose();
      valorController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<PedidoViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UsuarioViewmodel>().usuarioLogado = null;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Novo pedido'),
      ),
      body: viewmodel.carregandoPedidos && viewmodel.pedidos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : viewmodel.pedidos.isEmpty
              ? const Center(child: Text('Nenhum pedido cadastrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewmodel.pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = viewmodel.pedidos[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pedido.cliente} | ${pedido.prato}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('Quantidade: ${pedido.quantidade}'),
                            Text(
                              'Total: R\$ ${pedido.total.toStringAsFixed(2).replaceAll('.', ',')}',
                            ),
                            Text('Classificação: ${pedido.classificacao}'),
                            Text('Status: ${pedido.status}'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                FilledButton(
                                  onPressed: pedido.status.toLowerCase() ==
                                          'finalizado'
                                      ? null
                                      : () => _finalizar(pedido),
                                  child: const Text('FINALIZAR'),
                                ),
                                OutlinedButton(
                                  onPressed: () => _excluir(pedido),
                                  child: const Text('EXCLUIR'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
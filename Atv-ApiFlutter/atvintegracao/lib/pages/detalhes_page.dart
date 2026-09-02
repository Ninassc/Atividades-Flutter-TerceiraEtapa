import 'package:atvintegracao/widgets/linha_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voo_provider.dart';

class DetalhesPage extends StatefulWidget {
  final String aeroporto;
  final String tipo;
  final String identificacao;

  const DetalhesPage({
    super.key,
    required this.aeroporto,
    required this.tipo,
    required this.identificacao,
  });

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VooProvider>().carregarDetalhes(
            widget.aeroporto,
            widget.tipo,
            widget.identificacao,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VooProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do voo"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: provider.carregandoDetalhes
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.vooSelecionado == null
                  ? const Center(
                      child: Text("Não foi possível carregar o voo"),
                    )
                  : Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 97, 91, 91),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.vooSelecionado!["identificacao"] ??
                                  "Sem identificação",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.vooSelecionado!["categoria"] ??
                                  "Categoria não informada",
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 243, 238, 238),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),
                            LinhaInfo(
                              icone: Icons.flight_takeoff,
                              titulo: "Partida",
                              valor: provider.vooSelecionado!["partida"],
                            ),
                            LinhaInfo(
                              icone: Icons.flight_land,
                              titulo: "Chegada",
                              valor: provider.vooSelecionado!["chegada"],
                            ),
                            LinhaInfo(
                              icone: Icons.location_on_outlined,
                              titulo: "Local",
                              valor: provider.vooSelecionado!["local"],
                            ),
                            LinhaInfo(
                              icone: Icons.airplanemode_active,
                              titulo: "Tipo da aeronave",
                              valor: provider.vooSelecionado!["tipo_aeronave"],
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

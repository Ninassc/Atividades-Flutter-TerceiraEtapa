import 'package:atvintegracao/pages/detalhes_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voo_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> tipos = ['chegadas', 'partidas', 'todos'];
  String tipoSelecionado = 'todos';
  final TextEditingController controllerAeroporto = TextEditingController();

  late String aeroporto;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VooProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Voos"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: provider.voos == null
              ? Center(
                  child: const Text("Carregue os voos"),
                )
              : Column(
                  children: [
                    TextField(
                      controller: controllerAeroporto,
                      decoration:
                          InputDecoration(label: Text("ICAO do aeroporto")),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        ...tipos.map((tipo) {
                          return ChoiceChip(
                            label: Text(tipo),
                            selected: tipoSelecionado == tipo,
                            onSelected: (_) {
                              setState(() {
                                tipoSelecionado = tipo;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        aeroporto = controllerAeroporto.text.isNotEmpty
                            ? controllerAeroporto.text
                            : "SBGR";

                        context
                            .read<VooProvider>()
                            .carregarVoos(aeroporto, tipoSelecionado);

                        controllerAeroporto.clear();
                      },
                      child: const Text('Carregar Voos'),
                    ),
                    const SizedBox(height: 16),
                    provider.carregando
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                              itemCount: provider.voos.length,
                              itemBuilder: (context, index) {
                                final voo = provider.voos[index];

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetalhesPage(
                                                aeroporto: aeroporto,
                                                tipo: tipoSelecionado,
                                                identificacao:
                                                    voo["identificacao"])));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Identificação: ${voo["identificacao"] ?? 'N/A'}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("Local: ${voo['local']}")
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}

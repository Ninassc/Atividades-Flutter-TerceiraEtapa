import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voo_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          child: provider.carregando
              ? const Center(child: CircularProgressIndicator())
              : provider.voos == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Carregue os voos"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<VooProvider>().carregarVoos();
                            },
                            child: const Text('Buscar Todos'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Mantém o botão no topo caso ele queira atualizar a busca
                        ElevatedButton(
                          onPressed: () {
                            context.read<VooProvider>().carregarVoos();
                          },
                          child: const Text('Atualizar Voos'),
                        ),
                        const SizedBox(height: 16),

                        // Agora o Expanded funciona perfeitamente dentro da Column
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.voos.length,
                            itemBuilder: (context, index) {
                              final voo = provider.voos[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Identificação: ${voo["identificacao"] ?? 'N/A'}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
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

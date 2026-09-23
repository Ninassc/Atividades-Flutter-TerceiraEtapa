import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tarefa_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tarefaController = TextEditingController();

  @override
  void dispose() {
    tarefaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Tarefas',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: tarefaController,
              decoration: const InputDecoration(
                labelText: 'Digite uma tarefa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<TarefaProvider>();

                  await provider.adicionar(
                    tarefaController.text,
                  );

                  tarefaController.clear();
                },
                child: const Text(
                  'Adicionar tarefa',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<TarefaProvider>(
                builder: (
                  context,
                  provider,
                  child,
                ) {
                  if (provider.carregando) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.tarefas.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma tarefa cadastrada.',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = provider.tarefas[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarefa.concluida,
                            onChanged: (valor) {
                              provider.alterarStatus(
                                tarefa,
                              );
                            },
                          ),
                          title: Text(
                            tarefa.titulo,
                            style: TextStyle(
                              decoration: tarefa.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),
                            onPressed: () {
                              provider.excluir(
                                tarefa.id,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

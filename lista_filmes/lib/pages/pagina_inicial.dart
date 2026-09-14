import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/filme_viewmodel.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() {
    return _PaginaInicialState();
  }
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filmeViewModel = Provider.of<FilmeViewmodel>(context);

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
            // Campo para digitar a tarefa.
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Digite uma tarefa',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // Botão para cadastrar uma tarefa.
            ElevatedButton(
              onPressed: () {
                // Envia o texto para a ViewModel.
                filmeViewModel.adicionarFilme(
                  controller.text,
                );

                // Limpa o campo depois de cadastrar.
                controller.clear();
              },
              child: const Text(
                'Salvar',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Expanded permite que a lista
            // ocupe o espaço restante.
            Expanded(
              child: ListView.builder(
                // Quantidade de tarefas.
                itemCount: filmeViewModel.filmes.length,

                itemBuilder: (context, index) {
                  // Pega a tarefa da posição atual.
                  final filme = filmeViewModel.filmes[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          '${index + 1}',
                        ),
                      ),

                      // Mostra o título.
                      title: Text(
                        filme.titulo,

                        // Se estiver concluída,
                        // risca o texto.
                        style: TextStyle(
                          decoration: filme.assistido
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),

                      // Permite marcar/desmarcar.
                      trailing: Checkbox(
                        value: filme.assistido,
                        onChanged: (valor) {
                          filmeViewModel.alterarStatus(
                            filme,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:batalha_ideias/viewmodel/ideia_viewmodel.dart';

class IdeiasPage extends StatefulWidget {
  const IdeiasPage({super.key});

  @override
  State<IdeiasPage> createState() => _IdeiasPageState();
}

class _IdeiasPageState extends State<IdeiasPage> {
  final IdeiaViewmodel _viewModel = IdeiaViewmodel();

  @override
  void initState() {
    super.initState();
    _viewModel.carregarIdeias();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _exibirDialogCadastro(BuildContext context) {
    final tituloController = TextEditingController();
    final descricaoController = TextEditingController();
    final autorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastrar Nova Ideia'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ex: Torneio de Games',
                  ),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex: Sistema para criar torneios...',
                  ),
                ),
                TextField(
                  controller: autorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor',
                    hintText: 'Ex: Pedro',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tituloController.text.trim().isNotEmpty &&
                    descricaoController.text.trim().isNotEmpty &&
                    autorController.text.trim().isNotEmpty) {
                  await _viewModel.cadastrarIdeia(
                    tituloController.text,
                    descricaoController.text,
                    autorController.text,
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final ideiaMaisVotada = _viewModel.ideiaMaisVotada;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Batalha de Ideias'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _exibirDialogCadastro(context),
            icon: const Icon(Icons.add),
            label: const Text('Nova Ideia'),
          ),
          body: _viewModel.carregandoIdeias
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Banner Ranking: Ideia Mais Votada
                    if (ideiaMaisVotada != null) ...[
                      Card(
                        color: Colors.amber.shade100,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                '🏆 IDEIA MAIS VOTADA',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ideiaMaisVotada.titulo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${ideiaMaisVotada.quantidadeVotos} votos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Lista de Ideias Cadastradas
                    if (_viewModel.ideias.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            'Nenhuma ideia cadastrada ainda.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    else
                      ..._viewModel.ideias.map((ideia) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '🎮 ${ideia.titulo}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _viewModel.excluirIdeia(ideia.id),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Autor: ${ideia.autor}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ideia.descricao,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '❤️ ${ideia.quantidadeVotos} votos',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          _viewModel.votarIdeia(ideia),
                                      icon: const Icon(Icons.thumb_up),
                                      label: const Text('VOTAR'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
        );
      },
    );
  }
}

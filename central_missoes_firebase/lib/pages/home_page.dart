import 'package:central_missoes_firebase/provider/missao_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tituloController = TextEditingController();
  String _dificuldadeSelecionada = 'fácil';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MissaoProvider>(context, listen: false).carregarMissoes();
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  void _abrirModalNovaMissao() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova Missão',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título da Missão',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _dificuldadeSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Dificuldade',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'fácil',
                    child: Text('Fácil'),
                  ),
                  DropdownMenuItem(
                    value: 'médio',
                    child: Text('Médio'),
                  ),
                  DropdownMenuItem(
                    value: 'difícil',
                    child: Text('Difícil'),
                  ),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() {
                      _dificuldadeSelecionada = valor;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_tituloController.text.isNotEmpty) {
                    await Provider.of<MissaoProvider>(
                      context,
                      listen: false,
                    ).cadastrarMissao(
                      _tituloController.text,
                      _dificuldadeSelecionada,
                    );

                    _tituloController.clear();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getCorDificuldade(String dificuldade) {
    switch (dificuldade.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'médio':
        return Colors.orange;
      case 'difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final missaoProvider = Provider.of<MissaoProvider>(context);
    int pontos = 0;
    for (var missao in missaoProvider.missoes) {
      if (missao.concluida) {
        pontos += missao.pontos;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Missões'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: missaoProvider.carregandoMissoes
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : missaoProvider.missoes.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma missão cadastrada ainda!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurple.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pontos Acumulados:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            avatar: const Icon(Icons.star, color: Colors.amber),
                            label: Text(
                              '$pontos pts',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.amber.shade100,
                          ),
                        ],
                      ),
                    ),

                    // Lista de Missões
                    Expanded(
                      child: ListView.builder(
                        itemCount: missaoProvider.missoes.length,
                        itemBuilder: (context, index) {
                          final missao = missaoProvider.missoes[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: missao.concluida,
                                activeColor: Colors.deepPurple,
                                onChanged: (_) {
                                  missaoProvider.alterarStatus(missao);
                                },
                              ),
                              title: Text(
                                missao.titulo,
                                style: TextStyle(
                                  decoration: missao.concluida
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: missao.concluida
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _getCorDificuldade(missao.dificuldade)
                                              .withAlpha(50),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      missao.dificuldade.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _getCorDificuldade(
                                            missao.dificuldade),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  missao.dificuldade == "fácil"
                                      ? Icon(Icons.star, color: Colors.yellow)
                                      : missao.dificuldade == 'médiia'
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Icon(Icons.star,
                                                    color: Colors.yellow)
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.yellow),
                                                Icon(Icons.star,
                                                    color: Colors.yellow),
                                                Icon(Icons.star,
                                                    color: Colors.yellow)
                                              ],
                                            ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+${missao.pontos} pts',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  missaoProvider.excluirMissao(missao.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirModalNovaMissao,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova Missão'),
      ),
    );
  }
}

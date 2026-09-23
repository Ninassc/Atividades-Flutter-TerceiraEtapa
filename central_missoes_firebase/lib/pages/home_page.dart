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
    // Inicia a escuta dos dados ao carregar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MissaoProvider>(context, listen: false).carregarTarefas();
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      prefixIcon: Icon(Icons.assignment),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _dificuldadeSelecionada,
                    decoration: const InputDecoration(
                      labelText: 'Dificuldade',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.speed),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'fácil',
                        child: Text('Fácil (10 pts)'),
                      ),
                      DropdownMenuItem(
                        value: 'médio',
                        child: Text('Médio (20 pts)'),
                      ),
                      DropdownMenuItem(
                        value: 'difícil',
                        child: Text('Difícil (30 pts)'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setModalState(() {
                          _dificuldadeSelecionada = valor;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar Missão'),
                    onPressed: () async {
                      if (_tituloController.text.trim().isNotEmpty) {
                        await Provider.of<MissaoProvider>(context, listen: false)
                            .cadastrarMissao(
                          _tituloController.text,
                          _dificuldadeSelecionada,
                        );
                        _tituloController.clear();
                        if (mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Missões'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MissaoProvider>(
        builder: (context, provider, child) {
          if (provider.carregandoMissoes) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.missoes.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma missão cadastrada ainda!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Cálculo do total de pontos de missões concluídas
          final pontosTotais = provider.missoes
              .where((m) => m.concluida)
              .fold(0, (sum, m) => sum + m.pontos);

          return Column(
            children: [
              // Card com pontuação total
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
                        '$pontosTotais pts',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.amber.shade100,
                    ),
                  ],
                ),
              ),
              
              // Lista de Missões
              Expanded(
                child: ListView.builder(
                  itemCount: provider.missoes.length,
                  itemBuilder: (context, index) {
                    final missao = provider.missoes[index];

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
                            provider.alterarStatus(missao);
                          },
                        ),
                        title: Text(
                          missao.titulo,
                          style: TextStyle(
                            decoration: missao.concluida
                                ? TextDecoration.lineThrough
                                : null,
                            color: missao.concluida ? Colors.grey : Colors.black,
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
                                color: _getCorDificuldade(missao.dificuldade)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                missao.dificuldade.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _getCorDificuldade(missao.dificuldade),
                                ),
                              ),
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
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            provider.excluirMissao(missao.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
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
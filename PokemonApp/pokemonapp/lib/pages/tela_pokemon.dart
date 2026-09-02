import 'package:flutter/material.dart';
import 'package:pokemonapp/widgets/resultado.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';

class TelaPokemon extends StatelessWidget {
  const TelaPokemon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Nome / Tipo do Pokémon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final nomeBusca = controller.text.trim().toLowerCase();

                      if (nomeBusca.isNotEmpty) {
                        context
                            .read<PokemonProvider>()
                            .carregarDetalhesNome(nomeBusca);
                      }
                    },
                    child: const Text('Pesquisar Nome'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final tipoBusca = controller.text.trim().toLowerCase();

                      if (tipoBusca.isNotEmpty) {
                        context
                            .read<PokemonProvider>()
                            .carregarPokemonsTipo(tipoBusca);
                      }
                    },
                    child: const Text('Pesquisar Tipo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<PokemonProvider>().carregarPokemons();
                },
                child: const Text('Buscar Todos'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Resultado(provider: provider,),
            ),
          ],
        ),
      ),
    );
  }
}

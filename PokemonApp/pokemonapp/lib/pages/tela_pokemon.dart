import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import 'tela_detalhes_pokemon.dart';

class TelaPokemon extends StatelessWidget {
  const TelaPokemon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    dynamic pokemonEspecifico;

    TextEditingController controllerNome = TextEditingController();

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
              controller: controllerNome,
              decoration: const InputDecoration(
                labelText: 'Nome do Pokémon',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final nomeBusca = controllerNome.text.trim().toLowerCase();
                if (nomeBusca.isNotEmpty) {
                  context
                      .read<PokemonProvider>()
                      .carregarDetalhesNome(nomeBusca);
                }
              },
              child: const Text('Buscar Pokémon por Nome'),
            ),
            const SizedBox(height: 20),

            // Exibe o carregando
            if (provider.carregando) const CircularProgressIndicator(),

            // Exibe o card apenas se NÃO estiver carregando E houver um Pokémon selecionado
            if (!provider.carregando && provider.pokemonSelecionado != null)
              Card(
                child: ListTile(
                  leading: Image.network(
                    provider.pokemonSelecionado!['imagem'] ?? '',
                    width: 60,
                  ),
                  title: Text(
                    provider.pokemonSelecionado!['nome']
                        .toString()
                        .toUpperCase(),
                  ),
                  subtitle: Text(
                    'Tipos: ${(provider.pokemonSelecionado!['tipos'] as List).join(', ')}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TelaDetalhesPokemon(
                            idPokemon: provider.pokemonSelecionado!['id'],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PokemonProvider>().carregarPokemons();
              },
              child: const Text(
                'Buscar Pokémon',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (provider.carregando) const CircularProgressIndicator(),
            if (!provider.carregando)
              Expanded(
                child: ListView.builder(
                  itemCount: provider.pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = provider.pokemons[index];

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          pokemon['imagem'],
                          width: 60,
                        ),
                        title: Text(
                          pokemon['nome'].toString().toUpperCase(),
                        ),
                        subtitle: Text(
                          'Tipo: ${pokemon['tipo']}',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TelaDetalhesPokemon(
                                  idPokemon: pokemon['id'],
                                );
                              },
                            ),
                          );
                        },
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
}

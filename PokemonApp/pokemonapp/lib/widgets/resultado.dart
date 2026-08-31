import 'package:flutter/material.dart';
import 'package:pokemonapp/pages/tela_detalhes_pokemon.dart';
import 'package:pokemonapp/providers/pokemon_provider.dart';

class Resultado extends StatelessWidget {
  final PokemonProvider provider;
  const Resultado({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.carregando ||
        provider.carregandoTipo ||
        provider.carregandoEspecifico) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.pokemonSelecionado != null) {
      final pokemon = provider.pokemonSelecionado!;

      return ListView(
        children: [
          Card(
            child: ListTile(
              leading: Image.network(
                pokemon['imagem'] ?? '',
                width: 60,
              ),
              title: Text(
                pokemon['nome'].toString().toUpperCase(),
              ),
              subtitle: Text(
                'Tipos: ${(pokemon['tipos'] as List).join(', ')}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
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
          ),
        ],
      );
    }

    if (provider.pokemonsTipo.isNotEmpty) {
      return ListView.builder(
        itemCount: provider.pokemonsTipo.length,
        itemBuilder: (context, index) {
          final pokemon = provider.pokemonsTipo[index];

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
            ),
          );
        },
      );
    }

    return ListView.builder(
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
          ),
        );
      },
    );
  }
}

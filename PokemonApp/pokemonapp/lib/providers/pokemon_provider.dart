import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  List<dynamic> pokemons = [];
  List<dynamic> pokemonsTipo = [];

  Map<String, dynamic>? pokemonSelecionado;

  bool carregando = false;
  bool carregandoEspecifico = false;
  bool carregandoTipo = false;

  Future<void> carregarPokemons() async {
    carregando = true;

    // Limpa pesquisas anteriores
    pokemonSelecionado = null;
    pokemonsTipo = [];

    notifyListeners();

    pokemons = await PokemonService.buscarPokemons();

    carregando = false;

    notifyListeners();
  }

  Future<void> carregarPokemonsTipo(String tipo) async {
    carregandoTipo = true;

    // Limpa pesquisas anteriores
    pokemonSelecionado = null;
    pokemons = [];

    notifyListeners();

    pokemonsTipo = await PokemonService.buscarPokemonsTipo(tipo);

    carregandoTipo = false;

    notifyListeners();
  }

  Future<void> carregarDetalhes(
    int id,
  ) async {
    carregando = true;

    pokemonSelecionado = null;

    notifyListeners();

    pokemonSelecionado = await PokemonService.buscarDetalhes(
      id,
    );

    carregando = false;

    notifyListeners();
  }

  Future<void> carregarDetalhesNome(
    String nome,
  ) async {
    carregandoEspecifico = true;

    // Limpa pesquisas anteriores
    pokemonSelecionado = null;
    pokemons = [];
    pokemonsTipo = [];

    notifyListeners();

    pokemonSelecionado = await PokemonService.buscarDetalhesNome(
      nome,
    );

    carregandoEspecifico = false;

    notifyListeners();
  }
}
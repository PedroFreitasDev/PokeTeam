import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/search/models/pokemon_model.dart';
import 'constants/app_constants.dart';

class PokeApiService {
  static final PokeApiService _instance = PokeApiService._internal();
  factory PokeApiService() => _instance;
  PokeApiService._internal();

  Future<List<Map<String, dynamic>>> fetchPokemonList({
    int offset = 0,
    int limit = AppConstants.pokemonListLimit,
  }) async {
    final uri = Uri.parse(
        '${AppConstants.pokeApiBase}/pokemon?offset=$offset&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar lista de Pokémon');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(data['results'] as List);
  }

  Future<Pokemon> fetchPokemon(String nameOrId) async {
    final uri =
        Uri.parse('${AppConstants.pokeApiBase}/pokemon/$nameOrId');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Pokémon "$nameOrId" não encontrado');
    }

    return Pokemon.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  Future<List<Pokemon>> searchPokemon(String query) async {
    if (query.isEmpty) return [];
    try {
      final pokemon = await fetchPokemon(query.toLowerCase().trim());
      return [pokemon];
    } catch (_) {
      return [];
    }
  }
}

import 'package:flutter/foundation.dart';
import '../models/team_model.dart';
import '../../search/models/pokemon_model.dart';

class TeamsProvider extends ChangeNotifier {
  final List<PokemonTeam> _teams = [];

  List<PokemonTeam> get teams => List.unmodifiable(_teams);
  bool get hasTeams => _teams.isNotEmpty;

  void createTeam(String name) {
    final team = PokemonTeam(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _teams.add(team);
    notifyListeners();
  }

  void deleteTeam(String teamId) {
    _teams.removeWhere((t) => t.id == teamId);
    notifyListeners();
  }

  void renameTeam(String teamId, String newName) {
    final team = _teams.firstWhere((t) => t.id == teamId);
    team.name = newName;
    notifyListeners();
  }

  void addPokemonToTeam(String teamId, Pokemon pokemon) {
    final team = _teams.firstWhere((t) => t.id == teamId);
    if (!team.isFull) {
      team.addPokemon(pokemon);
      notifyListeners();
    }
  }

  void removePokemonFromTeam(String teamId, int index) {
    final team = _teams.firstWhere((t) => t.id == teamId);
    team.removePokemon(index);
    notifyListeners();
  }

  void setMove(String teamId, int pokemonId, int slot, String moveName) {
    final team = _teams.firstWhere((t) => t.id == teamId);
    team.setMove(pokemonId, slot, moveName);
    notifyListeners();
  }

  void clearMove(String teamId, int pokemonId, int slot) {
    final team = _teams.firstWhere((t) => t.id == teamId);
    team.clearMove(pokemonId, slot);
    notifyListeners();
  }

  PokemonTeam? getTeamById(String id) {
    try {
      return _teams.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}

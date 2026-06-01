import '../../search/models/pokemon_model.dart';

class PokemonTeam {
  final String id;
  String name;
  final List<Pokemon> members;
  // moves selecionados: chave = pokemonId, valor = lista de até 4 moves
  final Map<int, List<String>> selectedMoves;
  final DateTime createdAt;

  PokemonTeam({
    required this.id,
    required this.name,
    List<Pokemon>? members,
    Map<int, List<String>>? selectedMoves,
    DateTime? createdAt,
  })  : members = members ?? [],
        selectedMoves = selectedMoves ?? {},
        createdAt = createdAt ?? DateTime.now();

  bool get isFull => members.length >= 6;
  bool get isEmpty => members.isEmpty;
  int get memberCount => members.length;

  void addPokemon(Pokemon pokemon) {
    if (!isFull) {
      members.add(pokemon);
      selectedMoves[pokemon.id] = [];
    }
  }

  void removePokemon(int index) {
    if (index >= 0 && index < members.length) {
      final pid = members[index].id;
      members.removeAt(index);
      selectedMoves.remove(pid);
    }
  }

  List<String> movesFor(int pokemonId) => selectedMoves[pokemonId] ?? [];

  void setMove(int pokemonId, int slot, String moveName) {
    final moves = selectedMoves[pokemonId] ?? [];
    while (moves.length <= slot) moves.add('');
    moves[slot] = moveName;
    selectedMoves[pokemonId] = moves;
  }

  void clearMove(int pokemonId, int slot) {
    final moves = selectedMoves[pokemonId] ?? [];
    if (slot < moves.length) moves[slot] = '';
    selectedMoves[pokemonId] = moves;
  }
}

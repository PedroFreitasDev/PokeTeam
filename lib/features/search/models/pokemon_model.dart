class PokemonType {
  final String name;
  const PokemonType({required this.name});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(name: json['type']['name'] as String);
  }
}

class PokemonMove {
  final String name;
  const PokemonMove({required this.name});

  String get displayName =>
      name[0].toUpperCase() + name.substring(1).replaceAll('-', ' ');
}

class Pokemon {
  final int id;
  final String name;
  final List<PokemonType> types;
  final String spriteUrl;
  final int baseExperience;
  final int height;
  final int weight;
  final List<String> availableMoveNames; // nomes brutos vindos da API

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.spriteUrl,
    required this.baseExperience,
    required this.height,
    required this.weight,
    this.availableMoveNames = const [],
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final spriteUrl =
        sprites['other']?['official-artwork']?['front_default'] as String? ??
            sprites['front_default'] as String? ??
            '';

    final moves = (json['moves'] as List? ?? [])
        .map((m) => m['move']['name'] as String)
        .toList();

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      types: (json['types'] as List)
          .map((t) => PokemonType.fromJson(t as Map<String, dynamic>))
          .toList(),
      spriteUrl: spriteUrl,
      baseExperience: json['base_experience'] as int? ?? 0,
      height: json['height'] as int,
      weight: json['weight'] as int,
      availableMoveNames: moves,
    );
  }

  String get displayName =>
      name[0].toUpperCase() + name.substring(1).replaceAll('-', ' ');

  String get formattedId => '#${id.toString().padLeft(3, '0')}';
}

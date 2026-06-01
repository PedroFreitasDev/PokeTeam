import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/pokeapi_service.dart';
import '../models/pokemon_model.dart';
import '../../../shared/widgets/type_badge.dart';
import '../../../core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _service = PokeApiService();
  List<Pokemon> _results = [];
  bool _loading = false;
  String? _error;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() { _results = []; _error = null; });
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final results = await _service.searchPokemon(query);
      setState(() { _results = results; _loading = false; });
      if (results.isEmpty) setState(() => _error = 'Nenhum Pokémon encontrado.');
    } catch (e) {
      setState(() { _error = 'Erro na busca.'; _loading = false; });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Campo de busca
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.textDark, width: 3),
              color: AppTheme.surface,
              boxShadow: const [
                BoxShadow(color: AppTheme.textDark, offset: Offset(4, 4), blurRadius: 0),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.vt323(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Ex: pikachu, 25...',
                      hintStyle: GoogleFonts.vt323(fontSize: 18, color: AppTheme.textMuted),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: _search,
                  ),
                ),
                GestureDetector(
                  onTap: () => _search(_controller.text),
                  child: Container(
                    color: AppTheme.primaryRed,
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.search, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Resultados
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: CircularProgressIndicator(color: AppTheme.primaryRed),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(_error!, style: GoogleFonts.vt323(fontSize: 18, color: AppTheme.textMuted)),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final p = _results[i];
                  return _PokemonResultCard(pokemon: p);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PokemonResultCard extends StatelessWidget {
  final Pokemon pokemon;
  const _PokemonResultCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.textDark, width: 3),
        boxShadow: const [
          BoxShadow(color: AppTheme.textDark, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: pokemon.spriteUrl,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            placeholder: (_, __) => const SizedBox(width: 80, height: 80),
            errorWidget: (_, __, ___) => const Icon(
              Icons.catching_pokemon, size: 48, color: AppTheme.textMuted,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.formattedId,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 7, color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pokemon.displayName,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 9, color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: pokemon.types
                        .map((t) => TypeBadge(typeName: t.name))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context, '/pokemon-detail', arguments: pokemon,
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: AppTheme.primaryRed,
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

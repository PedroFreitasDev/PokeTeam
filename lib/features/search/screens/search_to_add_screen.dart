import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/pokeapi_service.dart';
import '../../search/models/pokemon_model.dart';
import '../../teams/models/teams_provider.dart';
import '../../../shared/widgets/type_badge.dart';
import '../../../core/theme/app_theme.dart';

class SearchToAddScreen extends StatefulWidget {
  const SearchToAddScreen({super.key});

  @override
  State<SearchToAddScreen> createState() => _SearchToAddScreenState();
}

class _SearchToAddScreenState extends State<SearchToAddScreen> {
  final _controller = TextEditingController();
  final _service = PokeApiService();
  List<Pokemon> _results = [];
  bool _loading = false;
  String? _error;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _service.searchPokemon(query);
      setState(() {
        _results = results;
        _loading = false;
      });
      if (results.isEmpty) {
        setState(() => _error = 'Nenhum Pokémon encontrado.');
      }
    } catch (e) {
      setState(() {
        _error = 'Erro na busca.';
        _loading = false;
      });
    }
  }

  void _addToTeam(BuildContext context, String teamId, Pokemon pokemon) {
    final provider = context.read<TeamsProvider>();
    final team = provider.getTeamById(teamId);
    if (team == null) return;

    if (team.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Time já está cheio! (6/6)',
            style: GoogleFonts.pressStart2p(fontSize: 7),
          ),
          backgroundColor: AppTheme.primaryRed,
        ),
      );
      return;
    }

    provider.addPokemonToTeam(teamId, pokemon);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${pokemon.displayName} adicionado!',
          style: GoogleFonts.vt323(fontSize: 18),
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BUSCAR POKÉMON',
          style: GoogleFonts.pressStart2p(fontSize: 9, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de busca
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.textDark, width: 3),
                color: AppTheme.surface,
                boxShadow: const [
                  BoxShadow(
                    color: AppTheme.textDark,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
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
                        hintStyle: GoogleFonts.vt323(
                          fontSize: 18,
                          color: AppTheme.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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

            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(color: AppTheme.primaryRed),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  _error!,
                  style: GoogleFonts.vt323(fontSize: 18, color: AppTheme.textMuted),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final p = _results[i];
                    return _AddPokemonCard(
                      pokemon: p,
                      onAdd: () => _addToTeam(context, teamId, p),
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

class _AddPokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onAdd;

  const _AddPokemonCard({required this.pokemon, required this.onAdd});

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
              Icons.catching_pokemon,
              size: 48,
              color: AppTheme.textMuted,
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
                      fontSize: 7,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pokemon.displayName,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 9,
                      color: AppTheme.textDark,
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
              onTap: onAdd,
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

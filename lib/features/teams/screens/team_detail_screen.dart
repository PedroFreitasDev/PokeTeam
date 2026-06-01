import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/teams_provider.dart';
import '../models/team_model.dart';
import '../../search/models/pokemon_model.dart';
import '../../../shared/widgets/type_badge.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../core/theme/app_theme.dart';

class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamId = ModalRoute.of(context)!.settings.arguments as String;
    final team = context.watch<TeamsProvider>().getTeamById(teamId);

    if (team == null) {
      return const Scaffold(body: Center(child: Text('Time não encontrado')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          team.name.toUpperCase(),
          style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // altura maior para caber sprite + nome + tipos + 4 moves
                  childAspectRatio: 0.62,
                ),
                itemCount: 6,
                itemBuilder: (context, i) {
                  if (i < team.members.length) {
                    return _FilledSlot(
                      team: team,
                      pokemon: team.members[i],
                      index: i,
                      teamId: teamId,
                      onRemove: () => context
                          .read<TeamsProvider>()
                          .removePokemonFromTeam(teamId, i),
                    );
                  }
                  return _EmptySlot(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/search-to-add',
                      arguments: teamId,
                    ),
                  );
                },
              ),
            ),
          ),
          // Botão fixo no rodapé
          SafeArea(
            top: false,
            child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: PixelButton(
              label: '+ ADICIONAR POKÉMON',
              fontSize: 7,
              onPressed: () => Navigator.pushNamed(
                context,
                '/search-to-add',
                arguments: teamId,
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Slot preenchido
// ──────────────────────────────────────────────
class _FilledSlot extends StatelessWidget {
  final PokemonTeam team;
  final Pokemon pokemon;
  final int index;
  final String teamId;
  final VoidCallback onRemove;

  const _FilledSlot({
    required this.team,
    required this.pokemon,
    required this.index,
    required this.teamId,
    required this.onRemove,
  });

  void _showMovePicker(BuildContext context, int slot) {
    final moves = pokemon.availableMoveNames;
    if (moves.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nenhum move disponível',
            style: GoogleFonts.vt323(fontSize: 18),
          ),
          backgroundColor: AppTheme.primaryRed,
        ),
      );
      return;
    }

    final current = team.movesFor(pokemon.id);
    final selectedInOtherSlots = List.generate(4, (i) {
      if (i == slot) return '';
      return i < current.length ? current[i] : '';
    }).where((m) => m.isNotEmpty).toSet();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AppTheme.textDark, width: 3),
      ),
      builder: (_) => _MovePickerSheet(
        moves: moves,
        disabledMoves: selectedInOtherSlots,
        currentMove: slot < current.length ? current[slot] : '',
        onSelect: (moveName) {
          context.read<TeamsProvider>().setMove(teamId, pokemon.id, slot, moveName);
          Navigator.pop(context);
        },
        onClear: () {
          context.read<TeamsProvider>().clearMove(teamId, pokemon.id, slot);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moves = team.movesFor(pokemon.id);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.textDark, width: 3),
        boxShadow: const [
          BoxShadow(color: AppTheme.textDark, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Sprite centralizado ──
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: SizedBox(
                  height: 72,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: pokemon.spriteUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    placeholder: (_, __) => const SizedBox(height: 72),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.catching_pokemon,
                      size: 56,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ),

              // ── Nome ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  pokemon.displayName,
                  style: GoogleFonts.pressStart2p(
                    fontSize: 6,
                    color: AppTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),

              // ── Tipos ──
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: pokemon.types
                      .map((t) => TypeBadge(typeName: t.name))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),

              // ── Divisor ──
              Container(height: 2, color: AppTheme.textDark.withOpacity(0.15)),
              const SizedBox(height: 6),

              // ── 4 slots de moves ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: List.generate(4, (slot) {
                    final moveName = slot < moves.length && moves[slot].isNotEmpty
                        ? moves[slot]
                        : null;
                    return _MoveSlot(
                      slot: slot,
                      moveName: moveName,
                      onTap: () => _showMovePicker(context, slot),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),

          // ── Botão remover ──
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                color: AppTheme.primaryRed,
                padding: const EdgeInsets.all(3),
                child: const Icon(Icons.close, color: Colors.white, size: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Slot individual de move
// ──────────────────────────────────────────────
class _MoveSlot extends StatelessWidget {
  final int slot;
  final String? moveName;
  final VoidCallback onTap;

  const _MoveSlot({required this.slot, this.moveName, required this.onTap});

  String get _label {
    if (moveName == null || moveName!.isEmpty) return 'MOVE ${slot + 1}';
    return moveName![0].toUpperCase() +
        moveName!.substring(1).replaceAll('-', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final filled = moveName != null && moveName!.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: filled ? AppTheme.primaryRed : const Color(0xFFF0EBE0),
          border: Border.all(
            color: filled
                ? AppTheme.textDark
                : AppTheme.textDark.withOpacity(0.25),
            width: filled ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _label,
                style: GoogleFonts.pressStart2p(
                  fontSize: 5,
                  color: filled ? Colors.white : AppTheme.textDark.withOpacity(0.35),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              filled ? Icons.edit : Icons.add,
              size: 10,
              color: filled ? Colors.white70 : AppTheme.textDark.withOpacity(0.25),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Bottom sheet para escolher move
// ──────────────────────────────────────────────
class _MovePickerSheet extends StatefulWidget {
  final List<String> moves;
  final Set<String> disabledMoves;
  final String currentMove;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  const _MovePickerSheet({
    required this.moves,
    required this.disabledMoves,
    required this.currentMove,
    required this.onSelect,
    required this.onClear,
  });

  @override
  State<_MovePickerSheet> createState() => _MovePickerSheetState();
}

class _MovePickerSheetState extends State<_MovePickerSheet> {
  late List<String> _filtered;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.moves;
    _searchCtrl.addListener(_filterMoves);
  }

  void _filterMoves() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.moves
          : widget.moves.where((m) => m.contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _fmt(String m) =>
      m[0].toUpperCase() + m.substring(1).replaceAll('-', ' ');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(top: BorderSide(color: AppTheme.textDark, width: 3)),
      ),
      child: Column(
        children: [
          // Título
          Container(
            color: AppTheme.primaryRed,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ESCOLHER MOVE',
                  style: GoogleFonts.pressStart2p(fontSize: 8, color: Colors.white),
                ),
                if (widget.currentMove.isNotEmpty)
                  GestureDetector(
                    onTap: widget.onClear,
                    child: Text(
                      'LIMPAR',
                      style: GoogleFonts.pressStart2p(
                          fontSize: 7, color: AppTheme.gold),
                    ),
                  ),
              ],
            ),
          ),

          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.textDark, width: 2),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.vt323(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Filtrar moves...',
                  hintStyle: GoogleFonts.vt323(fontSize: 18, color: AppTheme.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  suffixIcon: const Icon(Icons.search, size: 18),
                ),
              ),
            ),
          ),

          // Lista
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final move = _filtered[i];
                final disabled = widget.disabledMoves.contains(move);
                final selected = move == widget.currentMove;

                return GestureDetector(
                  onTap: disabled ? null : () => widget.onSelect(move),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryRed
                          : disabled
                              ? const Color(0xFFE0DAD0)
                              : AppTheme.surface,
                      border: Border.all(
                        color: selected
                            ? AppTheme.textDark
                            : AppTheme.textDark.withOpacity(0.2),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _fmt(move),
                            style: GoogleFonts.vt323(
                              fontSize: 18,
                              color: selected
                                  ? Colors.white
                                  : disabled
                                      ? AppTheme.textMuted.withOpacity(0.5)
                                      : AppTheme.textDark,
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check, size: 16, color: Colors.white),
                        if (disabled && !selected)
                          const Icon(Icons.block, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Slot vazio
// ──────────────────────────────────────────────
class _EmptySlot extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptySlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBE0),
          border: Border.all(
            color: AppTheme.textDark.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.add_circle_outline,
            size: 36,
            color: AppTheme.textDark.withOpacity(0.25),
          ),
        ),
      ),
    );
  }
}

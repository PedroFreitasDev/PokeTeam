import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/team_model.dart';
import '../../../core/theme/app_theme.dart';

class TeamCard extends StatelessWidget {
  final PokemonTeam team;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TeamCard({
    super.key,
    required this.team,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.textDark, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.textDark,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do card
            Container(
              color: AppTheme.primaryRed,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      team.name.toUpperCase(),
                      style: GoogleFonts.pressStart2p(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${team.memberCount}/6',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 7,
                          color: AppTheme.gold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Sprites dos membros
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: List.generate(6, (i) {
                  if (i < team.members.length) {
                    final p = team.members[i];
                    return Expanded(
                      child: CachedNetworkImage(
                        imageUrl: p.spriteUrl,
                        height: 48,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const SizedBox(height: 48),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.catching_pokemon,
                          size: 32,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.textDark.withOpacity(0.2),
                          width: 1,
                        ),
                        color: const Color(0xFFF0EBE0),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

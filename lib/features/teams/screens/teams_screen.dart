import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/teams_provider.dart';
import '../widgets/empty_teams_state.dart';
import '../widgets/team_card.dart';
import '../../../shared/widgets/pixel_button.dart';
import '../../../core/theme/app_theme.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  void _showCreateTeamDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'NOVO TIME',
          style: GoogleFonts.pressStart2p(fontSize: 10),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.vt323(fontSize: 20),
          decoration: InputDecoration(
            hintText: 'Nome do time...',
            hintStyle: GoogleFonts.vt323(fontSize: 20, color: AppTheme.textMuted),
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppTheme.primaryRed, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCELAR',
                style: GoogleFonts.pressStart2p(fontSize: 7, color: AppTheme.textMuted)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<TeamsProvider>().createTeam(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('CRIAR',
                style: GoogleFonts.pressStart2p(fontSize: 7, color: AppTheme.primaryRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeamsProvider>();

    return SafeArea(
      top: false,   // AppBar já cobre o topo (notch/status bar)
      bottom: true, // protege da gesture bar e barra de navegação nativa
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PixelButton(
              label: '+ NOVO TIME',
              onPressed: () => _showCreateTeamDialog(context),
            ),
            const SizedBox(height: 16),
            if (!provider.hasTeams)
              const EmptyTeamsState()
            else
              Expanded(
                child: ListView.separated(
                  itemCount: provider.teams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final team = provider.teams[i];
                    return TeamCard(
                      team: team,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/team-detail',
                        arguments: team.id,
                      ),
                      onDelete: () => context
                          .read<TeamsProvider>()
                          .deleteTeam(team.id),
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

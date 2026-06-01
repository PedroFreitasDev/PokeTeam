import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/teams/models/teams_provider.dart';
import 'features/teams/screens/home_screen.dart';
import 'features/teams/screens/team_detail_screen.dart';
import 'features/search/screens/search_to_add_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TeamsProvider(),
      child: const PokeTeamApp(),
    ),
  );
}

class PokeTeamApp extends StatelessWidget {
  const PokeTeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéTeam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/team-detail': (_) => const TeamDetailScreen(),
        '/search-to-add': (_) => const SearchToAddScreen(),
      },
    );
  }
}

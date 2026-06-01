import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../teams/screens/teams_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TeamsScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white),
            children: const [
              TextSpan(text: 'POK'),
              TextSpan(
                text: 'É',
                style: TextStyle(color: AppTheme.gold, fontSize: 16),
              ),
              TextSpan(text: 'TEAM'),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                // LED vermelho ligado
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFFF4444),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // LED desligado
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF888888),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26, width: 2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.textDark, width: 3)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: AppTheme.primaryRed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 8),
          unselectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 8),
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.groups, active: _currentIndex == 0),
              label: 'TIMES',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.search, active: _currentIndex == 1),
              label: 'BUSCAR',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _NavIcon({required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (active)
          Container(
            height: 3,
            width: 24,
            color: AppTheme.gold,
            margin: const EdgeInsets.only(bottom: 4),
          ),
        Icon(icon, color: active ? Colors.white : Colors.white54, size: 20),
      ],
    );
  }
}

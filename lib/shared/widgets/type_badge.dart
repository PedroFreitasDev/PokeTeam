import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeBadge extends StatelessWidget {
  final String typeName;
  const TypeBadge({super.key, required this.typeName});

  static const Map<String, Color> _typeColors = {
    'fire': Color(0xFFFF4422),
    'water': Color(0xFF3399FF),
    'grass': Color(0xFF77CC55),
    'electric': Color(0xFFFFCC00),
    'psychic': Color(0xFFFF5599),
    'ice': Color(0xFF66CCFF),
    'dragon': Color(0xFF7766EE),
    'dark': Color(0xFF775544),
    'fairy': Color(0xFFEE99EE),
    'normal': Color(0xFFAAAA88),
    'fighting': Color(0xFFBB5544),
    'flying': Color(0xFF8899FF),
    'poison': Color(0xFFAA5599),
    'ground': Color(0xFFDDBB55),
    'rock': Color(0xFFBBAA66),
    'bug': Color(0xFFAABB22),
    'ghost': Color(0xFF6666BB),
    'steel': Color(0xFFAAAABB),
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[typeName] ?? const Color(0xFF888888);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black45, width: 1.5),
      ),
      child: Text(
        typeName.toUpperCase(),
        style: GoogleFonts.pressStart2p(
          fontSize: 6,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class EmptyTeamsState extends StatelessWidget {
  const EmptyTeamsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
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
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pokébola SVG-like com CustomPaint
          _PokeballPainter(size: 56),
          const SizedBox(height: 16),
          Text(
            'SEM TIMES AINDA',
            style: GoogleFonts.pressStart2p(
              fontSize: 9,
              color: AppTheme.textDark,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Crie seu primeiro time e adicione\nPokémon pela aba Buscar.',
            style: GoogleFonts.vt323(
              fontSize: 18,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PokeballPainter extends StatelessWidget {
  final double size;
  const _PokeballPainter({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PokeballCustomPainter(),
    );
  }
}

class _PokeballCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final paintRed = Paint()..color = const Color(0xFFCC0000);
    final paintWhite = Paint()..color = Colors.white;
    final paintBlack = Paint()
      ..color = const Color(0xFF222222)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final paintBlackFill = Paint()..color = const Color(0xFF222222);

    // Top half red
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -3.14159,
        3.14159,
        true,
        paintRed);

    // Bottom half white
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        0,
        3.14159,
        true,
        paintWhite);

    // Outline
    canvas.drawCircle(Offset(cx, cy), r - 1.25, paintBlack);

    // Center line
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paintBlackFill..strokeWidth = 3);

    // Center button
    canvas.drawCircle(Offset(cx, cy), r * 0.28, paintWhite);
    canvas.drawCircle(Offset(cx, cy), r * 0.28, paintBlack);
    canvas.drawCircle(Offset(cx, cy), r * 0.14,
        Paint()..color = const Color(0xFFDDDDDD));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
